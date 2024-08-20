type t
type error

type staging =
  | Loading
  | Error(error)
  | Data(t)

let fetch: RescriptCore.JSON.t => promise<staging>

@react.component
let make: (~playerName: string, ~staging: staging) => Jsx.element
