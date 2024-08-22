type stagingGame = {
  id: string,
  desc: string,
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
      id: s.field("id", S.string->S.pattern(%re("/^[a-f0-9]{32}$/"))),
      desc: s.field("desc", S.string->S.stringMaxLength(50)),
      playersOrCodes: s.field(
        "playersOrCodes",
        S.array(S.string)->S.arrayMinLength(1)->S.arrayMaxLength(5),
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
// Failed parsing at ["game"]["id"]. Reason: Invalid

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
    <h1 className="font-amar text-center text-4xl"> {React.string("Staging")} </h1>
    {switch staging {
    | Loading =>
      <div className="absolute left-1/2 transform -translate-x-2/4 bottom-10">
        <Loading label="..." />
      </div>
    | Error(err) => <p className="my-3 bg-white"> {React.string(err)} </p>
    | Data(data) =>
      <div className="w-full h-48 bg-white px-1 pb-1">
        <h6 className="text-center underline mb-2"> {React.string(data.game.id)} </h6>
        <p className="text-sm break-all text-center"> {React.string(data.game.desc)} </p>
        {data.game.playersOrCodes
        ->Array.map(player => <p className="break-all text-center"> {React.string(player)} </p>)
        ->React.array}
      </div>
    }}
  </>
}
