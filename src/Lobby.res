type lobbyGame = {
  id: string,
  players: array<string>,
}

type t = {games: array<lobbyGame>}

type error = string

type lobby =
  | Loading
  | Error(error)
  | Data(t)

let lobbySchema = S.object(o => {
  games: o.field(
    "games",
    S.array(
      S.object(s => {
        id: s.field("id", S.string),
        players: s.field("players", S.array(S.string)->S.arrayMaxLength(5)),
      }),
    )->S.arrayLength(3),
  ),
})

let makeError = (e: string): error => e

let makeLobby = json => {
  let val = json->S.parseAnyWith(lobbySchema)

  switch val {
  | Ok(a) => Data(a)
  | Error(e) => Error(e->S.Error.message)
  }
}

let fetch = async bodyVal => {
  open Fetch
  let request = RequestInit.make(
    ~method_=Post,
    ~headers=HeadersInit.make({"Content-Type": "application/json"}),
    ~body=BodyInit.make(JSON.stringify(bodyVal)),
    (),
  )

  try {
    let req = await fetchWithInit(Router.Lobby, request)
    switch req->Response.ok {
    | true => {await Response.json(req)}->makeLobby
    | false =>
      Error(
        `${req
          ->Response.status
          ->Int.toString}: ${req->Response.statusText}`->makeError,
      )
    }
  } catch {
  | Exn.Error(e) =>
    switch Exn.message(e) {
    | Some(msg) => Error(`JS error thrown: ${msg}`->makeError)
    | None => Error("Some other exception has been thrown"->makeError)
    }
  }
}

// ~playerName, ~lobby
@react.component
let make = () => {
  <>
    <h1 className="font-amar text-center text-4xl"> {React.string("Lobby")} </h1>
    <div className="w-full h-36 bg-white px-1 pb-1">
      <h3 className="text-xs text-center underline mb-2">
        {React.string("Game no 1723957752542204596")}
      </h3>
      <p className="break-all text-center"> {React.string("aaa")} </p>
    </div>
    <div className="w-full h-36 bg-white px-1 pb-1">
      <h3 className="text-xs text-center underline mb-2">
        {React.string("Game no 1723957752542223010")}
      </h3>
      <p className="break-all text-center"> {React.string("aaa aaa aaa")} </p>
    </div>
    <div className="w-full h-36 bg-white px-1 pb-1">
      <h3 className="text-xs text-center underline mb-2">
        {React.string("Game no 1723957752542224536")}
      </h3>
      <p className="break-all text-center">
        {React.string("mmmmmmmmmmmm mmmmmmmmmmmm mmmmmmmmmmmm mmmmmmmmmmmm mmmmmmmmmmmm")}
      </p>
    </div>
  </>

  //   <div>
  //     <p> {React.string(`this is the lobby ${playerName}`)} </p>
  //     {switch lobby {
  //     | Loading =>
  //       <div className="absolute left-1/2 transform -translate-x-2/4 bottom-10">
  //         <Loading label="lobby..." />
  //       </div>
  //     | Error(err) => <p className="my-3 bg-white"> {React.string(err)} </p>
  //     | Data(data) =>
  //       data.games
  //       ->Array.map(game =>
  //         <div>
  //           <p className="my-3 bg-white"> {React.string(game.id)} </p>
  //           {game.players
  //           ->Array.map(player => <p className="my-3 bg-white"> {React.string(player)} </p>)
  //           ->React.array}
  //         </div>
  //       )
  //       ->React.array
  //     }}
  //   </div>
}
