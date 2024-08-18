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

module HeadersInit: {
  type t = headersInit

  external make: {..} => t = "%identity"
  external makeWithArray: array<(string, string)> => t = "%identity"
}

module Headers: {
  type t = headers

  @new external make: t = "Headers"
  @new external makeWithInit: headersInit => t = "Headers"

  @send external append: (t, string, string) => unit = "append"
  @send external delete: (t, string) => unit = "delete"
  /* entries */ /* very experimental */
  @send @return(null_to_opt)
  external get: (t, string) => option<string> = "get"
  @send external has: (t, string) => bool = "has"
  /* keys */ /* very experimental */
  @send external set: (t, string, string) => unit = "set"
  /* values */
  /* very experimental */
}

module BodyInit: {
  type t = bodyInit

  external make: string => t = "%identity"
}

module Body: {
  type t = body

  @send external json: t => promise<JSON.t> = "json"
  @send external text: t => promise<string> = "text"
}

module RequestInit: {
  type t = requestInit

  let make: (
    ~method_: requestMethod=?,
    ~headers: headersInit=?,
    ~body: bodyInit=?,
    ~referrer: string=?,
    ~integrity: string=?,
    ~keepalive: bool=?,
    unit,
  ) => t
}

module Request: {
  type t = request

  @new external make: string => t = "Request"
  @new external makeWithInit: (string, requestInit) => t = "Request"
  @new external makeWithRequest: t => t = "Request"
  @new external makeWithRequestInit: (t, requestInit) => t = "Request"

  let method_: t => requestMethod
  @get external url: t => string = "url"
  @get external headers: t => headers = "headers"
  @get external referrer: t => string = "referrer"
  @get external integrity: t => string = "integrity"
  @get external keepalive: t => bool = "keepalive"

  /* Body Impl */

  @send external json: t => promise<JSON.t> = "json"
  @send external text: t => promise<string> = "text"
}

module ResponseInit: {
  type t = responseInit

  let make: (~status: int=?, ~statusText: string=?, ~headers: headersInit=?, unit) => t
}

module Response: {
  type t = response

  @new external make: string => t = "Response"
  @new external makeWithInit: (string, responseInit) => t = "Response"
  @new external makeWithResponse: t => t = "Response"
  @new external makeWithResponseInit: (t, responseInit) => t = "Response"

  @val external error: unit => t = "error"
  @val external redirect: string => t = "redirect"
  @val external redirectWithStatus: (string, int /* enum-ish */) => t = "redirect"
  @get external headers: t => headers = "headers"
  @get external ok: t => bool = "ok"
  @get external redirected: t => bool = "redirected"
  @get external status: t => int = "status"
  @get external statusText: t => string = "statusText"
  @get external type_: t => string = "type"
  @get external url: t => string = "url"

  @send external json: t => promise<JSON.t> = "json"
  @send external text: t => promise<string> = "text"
}

@val external fetchWithInit: (Router.t, requestInit) => promise<response> = "fetch"
