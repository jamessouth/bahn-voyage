type t
type error

type staging =
  | Loading
  | Data(t)
  | Error(error)

let fetch: RescriptCore.JSON.t => promise<staging>

@react.component
let make: (~playerName: string, ~staging: staging) => Jsx.element
