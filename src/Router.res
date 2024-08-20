type t =
  | Home
  | @as("/staging") Staging
  | Game
  | Other

let urlStringToType = (url: RescriptReactRouter.url) =>
  switch url.path {
  | list{} => Home
  | list{"staging"} => Staging
  | list{"game"} => Game
  | _ => Other
  }

let typeToUrlString = t =>
  switch t {
  | Home => "/"
  | Staging => "/staging"
  | Game => "/game"
  | Other => ""
  }

let useRouter = () => urlStringToType(RescriptReactRouter.useUrl())
let replace = route => route->typeToUrlString->RescriptReactRouter.replace
let push = route => route->typeToUrlString->RescriptReactRouter.push
