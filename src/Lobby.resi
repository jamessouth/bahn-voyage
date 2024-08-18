type t
type error

type lobby =
  | Loading
  | Error(error)
  | Data(t)

let fetch: RescriptCore.JSON.t => promise<lobby>
// ~playerName: string, ~lobby: lobby
@react.component
let make: unit => Jsx.element
