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

let constructLobby = x => {
  let val = x->S.parseAnyWith(lobbySchema)

  switch val {
  | Ok(a) => Data(a)
  | Error(e) => Error(e->S.Error.message)
  }
}

@react.component
let make = (~playerName) => {
  <div> {React.string(`this is the lobby ${playerName}`)} </div>
}
