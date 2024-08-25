type navigator
@send @scope("clipboard")
external writeText: (navigator, string) => promise<unit> = "writeText"
@val external nav: navigator = "navigator"
@send external toString: int => string = "toString"

@get external classList: {..} => Dom.domTokenList = "classList"
@send external addClassList1: (Dom.domTokenList, string) => unit = "add"
@send external removeClassList1: (Dom.domTokenList, string) => unit = "remove"

let user_max_len = 12

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
  o.tag("kind", "data")
  Data({
    game: o.field(
      "game",
      S.object(s => {
        id: s.field("id", S.string->S.pattern(%re("/^\d{19}$/"))),
        playersOrCodes: s.field(
          "playersOrCodes",
          S.array(S.string->S.pattern(%re("/^[A-Za-z0-9+/]{32}$|^\w{3,12}$/")))
          ->S.arrayMinLength(2)
          ->S.arrayMaxLength(5),
        ),
      }),
    ),
  })
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
    | Some(msg) => Error(`JS fetch error thrown: ${msg}`->makeError)
    | None => Error("Some other fetch exception has been thrown"->makeError)
    }
  }
}

let writeToClipboard = async text => {
  try {
    await writeText(nav, text)
  } catch {
  | Exn.Error(e) =>
    switch Exn.message(e) {
    | Some(msg) => Console.log(`JS clipboard error thrown: ${msg}`)
    | None => Console.log("Some other exception has been thrown while writing to clipboard")
    }
  }
}

@react.component
let make = (~playerName, ~staging) => {
  Console.log2(playerName, staging)
  <>
    <h1 className="font-amar text-center text-black-dk drop-shadow-h1 text-7xl">
      {React.string("STAGING")}
    </h1>
    {switch staging {
    | Loading =>
      <div className="absolute left-1/2 transform -translate-x-2/4 bottom-10">
        <Loading label="..." />
      </div>
    | Error(err) => <p className="p-1 bg-yellow-rg text-center"> {React.string(err)} </p>
    | Data(data) =>
      <div className="w-full text-black-dk bg-yellow-rg px-1 pb-1 max-w-360">
        <h2 className="text-center text-xs underline "> {React.string(data.game.id)} </h2>
        <p className="text-sm italic text-center mb-4">
          {React.string(`A ${toString(Array.length(data.game.playersOrCodes))} player game`)}
        </p>
        {data.game.playersOrCodes
        ->Array.map(player => {
          switch String.length(player) > user_max_len {
          | true =>
            <p
              onClick={e => {
                let this = ReactEvent.Mouse.target(e)
                this->classList->addClassList1("copy")
                this["textContent"]->writeToClipboard->Promise.done
              }}
              onAnimationEnd={e => {
                ReactEvent.Animation.target(e)->classList->removeClassList1("copy")
              }}
              className="mb-3 text-center relative text-sm cursor-copy">
              {React.string(player)}
            </p>
          | false => <p className="mb-3 text-center font-bold text-lg"> {React.string(player)} </p>
          }
        })
        ->React.array}
        <p className="text-sm mt-4 text-center">
          {React.string("Read or send one code to each player")}
        </p>
        <p className="text-xs text-center"> {React.string("Tap a code to copy it")} </p>
      </div>
    }}
  </>
}
