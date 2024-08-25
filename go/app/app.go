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

	"time"

	"github.com/go-chi/chi/v5"
	// "github.com/joho/godotenv"
	// "github.com/pusher/pusher-http-go/v5"
	"github.com/urfave/negroni"
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

// func getRandomSlice(s string, leng int) string {
// 	k := rand.IntN(len(s) - (leng - 1))
// 	return s[k : k+leng]
// }

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

		// fmt.Println(r.Body)
		// err := json.NewDecoder(r.Body).Decode(&s)
		// fmt.Println("name", s)

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

			if slices.ContainsFunc(availableGames, func(g staging) bool {
				return g.Game.Id == gameNo
			}) {

			} else {

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
	// if err := godotenv.Load(); err != nil {
	// 	log.Fatalf("could not load .env file... %v", err)
	// }

	// appID := os.Getenv("PUSHER_APP_ID")
	// appKey := os.Getenv("PUSHER_APP_KEY")
	// appSecret := os.Getenv("PUSHER_APP_SECRET")
	// appCluster := os.Getenv("PUSHER_APP_CLUSTER")

	// pusher := &pusher.Client{
	// 	AppID:   appID,
	// 	Key:     appKey,
	// 	Secret:  appSecret,
	// 	Cluster: appCluster,
	// 	Secure:  true,
	// }

	r := chi.NewRouter()

	r.Post("/staging", getStaging())
	// r.Post("/pusher/auth", authenticateUsers(pusher))
	// r.Post("/start", startGame(pusher))

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

// var conns = make(map[string]string)

// from pusher tutorial
// func authenticateUsers(client *pusher.Client) http.HandlerFunc {
// 	return func(w http.ResponseWriter, r *http.Request) {
// 		// defer r.Body.Close()

// 		// Handle CORS
// 		w.Header().Set("Access-Control-Allow-Origin", "*")
// 		w.Header().Set("Access-Control-Allow-Methods", "POST, GET, OPTIONS, PUT, DELETE")
// 		w.Header().Set("Access-Control-Allow-Headers", "Accept, Content-Type, Content-Length, Accept-Encoding, X-CSRF-Token, Authorization")

// 		if r.Method == http.MethodOptions {
// 			return
// 		}
// 		// socket_id=211400.6425257&channel_name=private-gamestate-channel
// 		params, _ := io.ReadAll(r.Body)
// 		fmt.Println("params: ", string(params))

// 		cookie, _ := r.Cookie("bv_playername")
// 		fmt.Println("cookie", cookie.Name, cookie.Value)

// 		sock := bytes.Split(bytes.Split(params, []byte{38})[0], []byte{61})[1]
// 		fmt.Println("sss", string(sock))
// 		conns[string(sock)] = cookie.Value
// 		fmt.Println("cc", conns)
// 		response, err := client.AuthorizePrivateChannel(params)
// 		if err != nil {
// 			w.WriteHeader(http.StatusBadRequest)
// 			return
// 		}

// 		w.Write(response)
// 	}
// }
