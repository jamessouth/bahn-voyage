package app

import (
	"bytes"
	"encoding/base64"
	"encoding/json"
	"errors"
	"fmt"
	"io"
	"log"
	"math/rand/v2"
	"net/http"
	"os"
	"path"
	"regexp"
	"slices"
	"strings"
	"time"

	"github.com/centrifugal/centrifuge"
	"github.com/go-chi/chi/v5"

	// "github.com/joho/godotenv"
	"github.com/urfave/negroni"
)

type stagingInput struct {
	PlayerName      string `json:"playerName"`
	GameCode        string `json:"gameCode"`
	NumOtherPlayers int    `json:"numOtherPlayers"`
	HasCode         bool   `json:"-"`
}

type stagingGame struct {
	Id             string   `json:"id"`
	PlayersOrCodes []string `json:"playersOrCodes"`
	IsClosed       bool     `json:"-"`
}

type staging struct {
	Kind  string      `json:"kind"`
	Game  stagingGame `json:"game"`
	Error string      `json:"error,omitempty"`
}

var (
	availableGames = make([]staging, 3)
)

func setCacheControlHeader(w http.ResponseWriter, r *http.Request, next http.HandlerFunc) {
	str := ""

	if path.Clean(r.URL.Path) == "/" {
		str = "no-cache, no-store, must-revalidate"
	} else {
		str = "public, max-age=31536000, immutable"
	}

	w.Header().Set("Cache-Control", str)
	next(w, r)
}

func auth(h http.Handler) http.Handler {
	return http.HandlerFunc(func(w http.ResponseWriter, r *http.Request) {
		ctx := r.Context()
		cred := &centrifuge.Credentials{
			UserID: "",
		}
		newCtx := centrifuge.SetCredentials(ctx, cred)
		r = r.WithContext(newCtx)
		h.ServeHTTP(w, r)
	})
}

func checkInput(b []byte) (stagingInput, error) {
	var (
		maxLength            = 99
		nameRE               = regexp.MustCompile(`^\w{3,12}$`)
		codeRE               = regexp.MustCompile(`^[A-Za-z0-9+/]{32}$`)
		playerNameBytes      = []byte{112, 108, 97, 121, 101, 114, 78, 97, 109, 101}
		gameCodeBytes        = []byte{103, 97, 109, 101, 67, 111, 100, 101}
		numOtherPlayersBytes = []byte{110, 117, 109, 79, 116, 104, 101, 114, 80, 108, 97, 121, 101, 114, 115}
		body, blank          stagingInput
	)

	if len(b) > maxLength {
		return blank, fmt.Errorf("improper json input - too long: %d", len(b))
	}
	if bytes.Count(b, playerNameBytes) != 1 || bytes.Count(b, gameCodeBytes)+bytes.Count(b, numOtherPlayersBytes) != 1 {
		return blank, errors.New("improper json input - duplicate/missing key")
	}

	err := json.Unmarshal(b, &body)
	if err != nil {
		return blank, err
	}

	if !nameRE.MatchString(body.PlayerName) {
		return blank, errors.New("improper json input - bad playerName: " + body.PlayerName)
	}

	if len(body.GameCode) == 0 {
		if n := body.NumOtherPlayers; n != 1 && n != 2 && n != 3 && n != 4 {
			return blank, fmt.Errorf("improper json input - bad numOtherPlayers: %d", body.NumOtherPlayers)
		}
	} else {
		body.HasCode = true
		if !codeRE.MatchString(body.GameCode) {
			return blank, errors.New("improper json input - bad gameCode: " + body.GameCode)
		}
	}

	return body, nil
}

func getCode(l, i int, sl []byte) string {
	var buf bytes.Buffer
	buf.Write(sl)
	for range l {
		buf.WriteRune(rand.Int32N(26) + 97)
	}
	buf.WriteByte(byte(i + 49))

	return base64.StdEncoding.EncodeToString(buf.Bytes())
}

func getStaging() http.HandlerFunc {
	return func(w http.ResponseWriter, r *http.Request) {
		// defer r.Body.Close()

		// Handle CORS
		w.Header().Set("Access-Control-Allow-Origin", "*")
		w.Header().Set("Access-Control-Allow-Methods", "POST, GET, OPTIONS, PUT, DELETE")
		w.Header().Set("Access-Control-Allow-Headers", "Accept, Content-Type, Content-Length, Accept-Encoding, X-CSRF-Token, Authorization")

		if r.Method != http.MethodPost {
			return
		}

		body, err := io.ReadAll(r.Body)
		if err != nil {
			fmt.Println("readall:", err)
		}

		checkedBody, err := checkInput(body)
		if err != nil {
			fmt.Println("checkinput:", err)
		}
		var b []byte

		if checkedBody.HasCode { //existing games
			decoded, err := base64.StdEncoding.DecodeString(checkedBody.GameCode)
			if err != nil {
				fmt.Println("decode error:", err)
			}
			gameNo := string(decoded[:19])

			n, found := slices.BinarySearchFunc(availableGames, staging{
				Kind: "",
				Game: stagingGame{
					Id:             gameNo,
					PlayersOrCodes: []string{},
					IsClosed:       false,
				},
				Error: "",
			}, func(a, b staging) int {
				return strings.Compare(a.Game.Id, b.Game.Id)
			})

			if found { //game found

				ind := -1
				for i, v := range availableGames[n].Game.PlayersOrCodes {
					if v == checkedBody.GameCode {
						ind = i
						break
					}
				}

				if ind > -1 { //code found
					availableGames[n].Game.PlayersOrCodes[ind] = checkedBody.PlayerName

					gameToSend := availableGames[n]
					hideCodes := []string{}
					for _, v := range gameToSend.Game.PlayersOrCodes {
						if len(v) > 12 {
							v = "waiting..."
						}
						hideCodes = append(hideCodes, v)
					}
					gameToSend.Game.PlayersOrCodes = hideCodes

					b, err = json.Marshal(gameToSend)
					if err != nil {
						fmt.Println("marshal error:", err)
					}

				} else { //code not found
					b, err = json.Marshal(staging{Kind: "error", Error: "incorrect code"})
					if err != nil {
						fmt.Println("marshal error:", err)
					}
				}

			} else { //game not found

				b, err = json.Marshal(staging{Kind: "error", Error: "game not found"})
				if err != nil {
					fmt.Println("marshal error:", err)
				}
			}

		} else { //new games

			for i, ag := range availableGames {
				if !ag.Game.IsClosed {

					var (
						codes  []string
						gameNo = fmt.Appendf([]byte{}, "%d", time.Now().UnixNano())
					)
					for i := range checkedBody.NumOtherPlayers {
						codes = append(codes, getCode(4, i, gameNo))
					}

					availableGames[i] = staging{
						Game: stagingGame{
							Id:             string(gameNo),
							PlayersOrCodes: append([]string{checkedBody.PlayerName}, codes...),
							IsClosed:       true,
						},
						Kind: "data",
					}

					b, err = json.Marshal(availableGames[i])
					if err != nil {
						fmt.Println("marshal error:", err)
					}

					break
				}
			}

		}
		for _, v := range availableGames {
			fmt.Printf("%+v\n", v)
		}
		fmt.Println()
		os.Stdout.Write(b)
		fmt.Println()

		w.Write(b)

	}
}

func Init() {
	for i := range availableGames {
		availableGames[i].Game.Id = "9999999999999999999"
	}
	// if err := godotenv.Load(); err != nil {
	// 	log.Fatalf("could not load .env file... %v", err)
	// }

	node, err := centrifuge.New(centrifuge.Config{})
	if err != nil {
		log.Fatal(err)
	}

	node.OnConnect(func(client *centrifuge.Client) {
		// In our example transport will always be Websocket but it can be different.
		transportName := client.Transport().Name()
		// In our example clients connect with JSON protocol but it can also be Protobuf.
		transportProto := client.Transport().Protocol()
		log.Printf("client connected via %s (%s)", transportName, transportProto)

		client.OnSubscribe(func(e centrifuge.SubscribeEvent, cb centrifuge.SubscribeCallback) {
			log.Printf("client subscribes on channel %s", e.Channel)
			cb(centrifuge.SubscribeReply{}, nil)
		})

		client.OnPublish(func(e centrifuge.PublishEvent, cb centrifuge.PublishCallback) {
			log.Printf("client publishes into channel %s: %s", e.Channel, string(e.Data))
			cb(centrifuge.PublishReply{}, nil)
		})

		// Set Disconnect handler to react on client disconnect events.
		client.OnDisconnect(func(e centrifuge.DisconnectEvent) {
			log.Printf("client disconnected")
		})
	})

	if err := node.Run(); err != nil {
		log.Fatal(err)
	}

	r := chi.NewRouter()

	r.Post("/staging", getStaging())
	wsHandler := centrifuge.NewWebsocketHandler(node, centrifuge.WebsocketConfig{})
	r.Handle("/connection/websocket", auth(wsHandler))

	n := negroni.New()
	n.Use(negroni.NewLogger())
	n.Use(negroni.NewRecovery())
	n.Use(negroni.HandlerFunc(setCacheControlHeader))
	n.Use(negroni.NewStatic(http.Dir("./dist")))
	n.UseHandler(r)

	port, ok := os.LookupEnv("PORT")
	if !ok {
		port = "8000"
	}
	log.Println("server running on port " + port)

	srv := &http.Server{
		Handler:      n,
		Addr:         "127.0.0.1:" + port,
		WriteTimeout: 10 * time.Second,
		ReadTimeout:  10 * time.Second,
	}

	log.Fatal(srv.ListenAndServe())

}
