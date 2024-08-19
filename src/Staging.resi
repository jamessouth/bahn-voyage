type t
type error

type lobby =
  | Loading
  | Error(error)
  | Data(t)

let fetch: RescriptCore.JSON.t => promise<lobby>

@react.component
let make: (~playerName: string, ~lobby: lobby) => Jsx.element
