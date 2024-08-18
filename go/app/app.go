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

const numLobbyGames = 3

type req struct {
	PlayerName string `json:"playerName"`
}

type game struct {
	Id      string `json:"id"`
	Players []req  `json:"players"`
}

type lobby struct {
	Games []game `json:"games"`
}

var (
	lobbyGames = lobby{
		Games: []game{},
	}
)

func getLobby() http.HandlerFunc {
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

		var s req

		err := json.NewDecoder(r.Body).Decode(&s)
		if err != nil {
			fmt.Println("g", err)
		}
		fmt.Println("name", s.PlayerName)

		for len(lobbyGames.Games) < numLobbyGames {
			lobbyGames.Games = append(lobbyGames.Games, game{
				Id:      fmt.Sprintf("%d", time.Now().UnixNano()),
				Players: []req{},
			})
		}

		b, err := json.Marshal(lobbyGames)
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

	r.Post("/lobby", getLobby())
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
