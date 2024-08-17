type lobbyGame = {
  id: string,
  players: array<string>,
}

type t = array<lobbyGame>

type error = string

type lobby =
  | Loading
  | Error(error)
  | Data(t)

let lobbySchema = S.array(
  S.object(s => {
    id: s.field("id", S.string),
    players: s.field("players", S.array(S.string)->S.arrayMaxLength(5)),
  }),
)->S.arrayLength(3)
let makeError = (e: string): error => e

let makeLobby = json => {
  let val = json->S.parseAnyWith(lobbySchema)

  switch val {
  | Ok(a) => Data(a)
  | Error(e) => Error(e->S.Error.message)
  }
}

let fetch = async (route, bodyVal, func: (t => t) => unit) => {
  open Fetch
  let request = RequestInit.make(
    ~method_=Post,
    ~headers=HeadersInit.make({"Content-Type": "application/json"}),
    ~body=BodyInit.make(JSON.stringify(bodyVal)),
    (),
  )

  let res = try {
    let req = await fetchWithInit(route, request)
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

  switch res {
  | Loading => ()
  | Data(d) => func(_ => d)
  | Error(e) => Console.log(e)
  }
}

@react.component
let make = (~playerName) => {
  <div> {React.string(`this is the lobby ${playerName}`)} </div>
}
