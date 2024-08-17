type body
type bodyInit
type headers
type headersInit
type response
type responseInit
type request
type requestInit

type requestMethod =
  | Get
  | Head
  | Post
  | Put
  | Delete
  | Connect
  | Options
  | Trace
  | Patch
  | Other(string)
let encodeRequestMethod = x =>
  /* internal */

  switch x {
  | Get => "GET"
  | Head => "HEAD"
  | Post => "POST"
  | Put => "PUT"
  | Delete => "DELETE"
  | Connect => "CONNECT"
  | Options => "OPTIONS"
  | Trace => "TRACE"
  | Patch => "PATCH"
  | Other(method_) => method_
  }
let decodeRequestMethod = x =>
  /* internal */

  switch x {
  | "GET" => Get
  | "HEAD" => Head
  | "POST" => Post
  | "PUT" => Put
  | "DELETE" => Delete
  | "CONNECT" => Connect
  | "OPTIONS" => Options
  | "TRACE" => Trace
  | "PATCH" => Patch
  | method_ => Other(method_)
  }

module HeadersInit = {
  type t = headersInit

  external make: {..} => t = "%identity"
  external makeWithArray: array<(string, string)> => t = "%identity"
}

module Headers = {
  type t = headers

  @new external make: t = "Headers"
  @new external makeWithInit: headersInit => t = "Headers"

  @send external append: (t, string, string) => unit = "append"
  @send external delete: (t, string) => unit = "delete"
  @send @return(null_to_opt)
  external get: (t, string) => option<string> = "get"
  @send external has: (t, string) => bool = "has"
  @send external set: (t, string, string) => unit = "set"
}

module BodyInit = {
  type t = bodyInit

  external make: string => t = "%identity"
}

module Body = {
  module Impl = (
    T: {
      type t
    },
  ) => {
    @send external json: T.t => promise<JSON.t> = "json"
    @send external text: T.t => promise<string> = "text"
  }

  type t = body
  include Impl({
    type t = t
  })
}

module RequestInit = {
  type t = requestInit

  let map = (f, x) =>
    /* internal */
    switch x {
    | Some(v) => Some(f(v))
    | None => None
    }

  @obj
  external make: (
    @as("method") ~_method: string=?,
    ~headers: headersInit=?,
    ~body: bodyInit=?,
    ~referrer: string=?,
    ~referrerPolicy: string=?,
    ~mode: string=?,
    ~credentials: string=?,
    ~cache: string=?,
    ~redirect: string=?,
    ~integrity: string=?,
    ~keepalive: bool=?,
    unit,
  ) => requestInit = ""
  let make = (
    ~method_: option<requestMethod>=?,
    ~headers: option<headersInit>=?,
    ~body: option<bodyInit>=?,
    ~referrer: option<string>=?,
    ~integrity: string="",
    ~keepalive: option<bool>=?,
    (),
  ) =>
    make(
      ~_method=?map(encodeRequestMethod, method_),
      ~headers?,
      ~body?,
      ~referrer?,
      ~integrity,
      ~keepalive?,
      (),
    )
}

module Request = {
  type t = request

  include Body.Impl({
    type t = t
  })

  @new external make: string => t = "Request"
  @new external makeWithInit: (string, requestInit) => t = "Request"
  @new external makeWithRequest: t => t = "Request"
  @new external makeWithRequestInit: (t, requestInit) => t = "Request"

  @get external method_: t => string = "method"
  let method_: t => requestMethod = self => decodeRequestMethod(method_(self))
  @get external url: t => string = "url"
  @get external headers: t => headers = "headers"
  @get external referrer: t => string = "referrer"
  @get external integrity: t => string = "integrity"
  @get external keepalive: t => bool = "keepalive"
}

module ResponseInit = {
  type t = responseInit

  @obj
  external make: (
    ~status: int=?,
    ~statusText: string=?,
    ~headers: headersInit=?,
    unit,
  ) => responseInit = ""
  let make = (
    ~status: option<int>=?,
    ~statusText: option<string>=?,
    ~headers: option<headersInit>=?,
    (),
  ) => make(~status?, ~statusText?, ~headers?, ())
}

module Response = {
  type t = response

  include Body.Impl({
    type t = t
  })

  @new external make: string => t = "Response"
  @new external makeWithInit: (string, responseInit) => t = "Response"
  @new external makeWithResponse: t => t = "Response"
  @new external makeWithResponseInit: (t, responseInit) => t = "Response"

  @val external error: unit => t = "error"
  @val external redirect: string => t = "redirect"
  @val external redirectWithStatus: (string, int) => t = "redirect"
  @get external headers: t => headers = "headers"
  @get external ok: t => bool = "ok"
  @get external redirected: t => bool = "redirected"
  @get external status: t => int = "status"
  @get external statusText: t => string = "statusText"
  @get external type_: t => string = "type"
  @get external url: t => string = "url"
}

@val external fetchWithInit: (string, requestInit) => promise<response> = "fetch"
