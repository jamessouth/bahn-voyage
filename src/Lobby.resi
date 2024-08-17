type t
type error

type lobby =
  | Loading
  | Error(error)
  | Data(t)

let makeError: string => error
let constructLobby: 'a => lobby

@react.component
let make: (~playerName: string) => Jsx.element
