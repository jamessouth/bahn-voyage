type t
type error

type lobby =
  | Loading
  | Error(error)
  | Data(t)

let makeError: string => error
let makeLobby: 'a => lobby
let fetch: (string, RescriptCore.JSON.t, (t => t) => unit) => promise<unit>

@react.component
let make: (~playerName: string) => Jsx.element
