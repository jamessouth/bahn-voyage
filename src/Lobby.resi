type t
type error

type lobby =
  | Loading
  | Error(error)
  | Data(t)

@react.component
let make: (~playerName: string) => Jsx.element
