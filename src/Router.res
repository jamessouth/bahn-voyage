type t =
  | Home
  | @as("/lobby") Lobby
  | Game
  | Other

let urlStringToType = (url: RescriptReactRouter.url) =>
  switch url.path {
  | list{} => Home
  | list{"lobby"} => Lobby
  | list{"game"} => Game
  | _ => Other
  }

let typeToUrlString = t =>
  switch t {
  | Home => "/"
  | Lobby => "/lobby"
  | Game => "/game"
  | Other => ""
  }

let useRouter = () => urlStringToType(RescriptReactRouter.useUrl())
let replace = route => route->typeToUrlString->RescriptReactRouter.replace
let push = route => route->typeToUrlString->RescriptReactRouter.push
