type t = array<game>

type error = string

type lobby =
  | Loading
  | Error(error)
  | Data(t)

let baconStruct = S.array(S.string())

let constructBacon = x => {
  let val = x->S.parseAnyWith(baconStruct)

  switch val {
  | Ok(a) => Data(a)
  | Error(e) => Error(e->S.Error.toString)
  }
}

@react.component
let make = (~playerName) => {
  <div> {React.string(`this is the lobby ${playerName}`)} </div>
}
