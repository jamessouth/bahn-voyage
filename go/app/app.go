package app

import (
	"encoding/json"
	"fmt"
	"log"
	"net/http"
	"os"
	"path"
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

const numConcurrentGames = 3

type stagingInput struct {
	PlayerName      string `json:"playerName"`
	GameCode        string `json:"gameCode"`
	NumOtherPlayers string `json:"numOtherPlayers"`
}

type stagingGame struct {
	Id      string   `json:"id"`
	Desc    string   `json:"desc"`
	Players []string `json:"players"`
}

type staging struct {
	Game stagingGame `json:"game"`
}

var (
	stagedGame = staging{
		Game: stagingGame{},
	}
)

// func checkInput(s string) (string, string, error) {
// 	var (
// 		maxLength = 99
// 		gamenoRE  = regexp.MustCompile(`^\d{19}$`)
// 		commandRE = regexp.MustCompile(`^join$|^leave$`)
// 		body      struct{ Gameno, Command string }
// 	)

// 	if len(s) > maxLength {
// 		return "", "", fmt.Errorf("improper json input - too long: %d", len(s))
// 	}

// 	if strings.Count(s, "gameno") != 1 || strings.Count(s, "command") != 1 {
// 		return "", "", errors.New("improper json input - duplicate/missing key")
// 	}

// 	err := json.Unmarshal([]byte(s), &body)
// 	if err != nil {
// 		return "", "", err
// 	}

// 	var gameno, command = body.Gameno, body.Command

// 	switch {
// 	case !gamenoRE.MatchString(gameno):
// 		return "", "", errors.New("improper json input - bad gameno: " + gameno)
// 	case !commandRE.MatchString(command):
// 		return "", "", errors.New("improper json input - bad command: " + command)
// 	}

// 	return gameno, command, nil
// }

// checkedGameno, checkedCommand, err := checkInput(bod)
// 	if err != nil {
// 		return callErr(err)
// 	}

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

		var s string

		err := json.NewDecoder(r.Body).Decode(&s)
		if err != nil {
			fmt.Println("g", err)
		}
		fmt.Println("name", s)

		b, err := json.Marshal(stagedGame)
		if err != nil {
			fmt.Println("error:", err)
		}
		os.Stdout.Write(b)

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
