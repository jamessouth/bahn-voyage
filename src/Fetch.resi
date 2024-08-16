// adapted from https://github.com/TheSpyder/rescript-webapi/blob/main/src/Webapi/Webapi__Fetch.resi

type body
type bodyInit
type headers
type headersInit
type responseInit
type response
type request
type requestInit

/* external */
type urlSearchParams /* URL */

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

type referrerPolicy =
  | None
  | NoReferrer
  | NoReferrerWhenDowngrade
  | SameOrigin
  | Origin
  | StrictOrigin
  | OriginWhenCrossOrigin
  | StrictOriginWhenCrossOrigin
  | UnsafeUrl

type requestDestination =
  | None /* default? unknown? just empty string in spec */
  | Document
  | Embed
  | Font
  | Image
  | Manifest
  | Media
  | Object
  | Report
  | Script
  | ServiceWorker
  | SharedWorker
  | Style
  | Worker
  | Xslt

type requestMode =
  | Navigate
  | SameOrigin
  | NoCORS
  | CORS

type requestCredentials =
  | Omit
  | SameOrigin
  | Include

type requestCache =
  | Default
  | NoStore
  | Reload
  | NoCache
  | ForceCache
  | OnlyIfCached

type requestRedirect =
  | Follow
  | Error
  | Manual

module HeadersInit: {
  type t = headersInit

  external make: {..} => t = "%identity"
  external makeWithDict: Dict.t<string> => t = "%identity"
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
  external makeWithUrlSearchParams: urlSearchParams => t = "%identity"
}

module Body: {
  type t = body

  @get external bodyUsed: t => bool = "bodyUsed"

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
    ~referrerPolicy: referrerPolicy=?,
    ~mode: requestMode=?,
    ~credentials: requestCredentials=?,
    ~cache: requestCache=?,
    ~redirect: requestRedirect=?,
    ~integrity: string=?,
    ~keepalive: bool=?,
    unit,
  ) => t
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

  @send external clone: t => t = "clone"

  /* Body.Impl */
  @get external bodyUsed: t => bool = "bodyUsed"

  @send external json: t => promise<JSON.t> = "json"
  @send external text: t => promise<string> = "text"
}

@val external fetchWithInit: (string, requestInit) => promise<response> = "fetch"
