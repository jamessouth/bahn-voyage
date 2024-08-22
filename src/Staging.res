@send external toString: int => string = "toString"

type stagingGame = {
  id: string,
  playersOrCodes: array<string>,
}

type t = {game: stagingGame}

type error = string

type staging =
  | Loading
  | Error(error)
  | Data(t)

let stagingSchema = S.object(o => {
  game: o.field(
    "game",
    S.object(s => {
      id: s.field("id", S.string->S.pattern(%re("/^\d{19}$/"))),
      playersOrCodes: s.field(
        "playersOrCodes",
        S.array(S.string->S.pattern(%re("/^[a-f0-9]{32}$|^\w{3,12}$/")))
        ->S.arrayMinLength(2)
        ->S.arrayMaxLength(5),
      ),
    }),
  ),
})

let makeError = (e: string): error => e

let makeStaging = json => {
  let val = json->S.parseAnyWith(stagingSchema)

  switch val {
  | Ok(a) => Data(a)
  | Error(e) =>
    Console.log("here")
    Error(e->S.Error.message)
  }
}

let fetch = async bodyVal => {
  open Fetch
  let request = RequestInit.make(
    ~method_=Post,
    ~headers=HeadersInit.make({"Content-Type": "application/json"}),
    ~body=BodyInit.make(JSON.stringify(bodyVal)),
    (),
  )

  try {
    let req = await fetchWithInit(Router.Staging, request)
    switch req->Response.ok {
    | true => {await Response.json(req)}->makeStaging
    | false =>
      Error(
        `${req
          ->Response.status
          ->Int.toString}: ${req->Response.statusText}`->makeError,
      )
    }
  } catch {
  | Exn.Error(e) =>
    switch Exn.message(e) {
    | Some(msg) => Error(`JS error thrown: ${msg}`->makeError)
    | None => Error("Some other exception has been thrown"->makeError)
    }
  }
}

@react.component
let make = (~playerName, ~staging) => {
  Console.log2(playerName, staging)
  <>
    <h1 className="font-amar text-center text-black-dk text-7xl"> {React.string("STAGING")} </h1>
    {switch staging {
    | Loading =>
      <div className="absolute left-1/2 transform -translate-x-2/4 bottom-10">
        <Loading label="..." />
      </div>
    | Error(err) => <p className="p-1 bg-yellow-rg text-center"> {React.string(err)} </p>
    | Data(data) =>
      <div className="w-full text-black-dk bg-yellow-rg px-1 pb-1 max-w-316">
        <h2 className="text-center text-xs underline "> {React.string(data.game.id)} </h2>
        <p className="text-sm italic text-center mb-3">
          {React.string(`A ${toString(Array.length(data.game.playersOrCodes))} player game`)}
        </p>
        {data.game.playersOrCodes
        ->Array.map(player => {
          let bold = switch String.length(player) > 12 {
          | true => ""
          | false => " font-bold text-lg"
          }
          <p className={"mb-2 text-center" ++ bold}> {React.string(player)} </p>
        })
        ->React.array}
        <p className="text-sm mt-3 text-center"> {React.string("Send one code to each player")} </p>
        <p className="text-xs  text-center"> {React.string("Tap to copy")} </p>
      </div>
    }}
  </>
}
