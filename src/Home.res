let user_min_len = 3
let user_max_len = 12

let fetch = async (route, bodyVal) => {
  let request = Fetch.RequestInit.make(
    ~method_=Fetch.Post,
    ~headers=Fetch.HeadersInit.make({"Content-Type": "application/json"}),
    ~body=Fetch.BodyInit.make(JSON.stringify(bodyVal)),
    (),
  )

  let val = try {
    let req = await Fetch.fetchWithInit(route, request)
    switch req->Fetch.Response.ok {
    | true => {await Fetch.Response.json(req)}->Lobby.constructLobby
    | false =>
      Error(
        `${req
          ->Fetch.Response.status
          ->Int.toString}: ${req->Fetch.Response.statusText}`->Lobby.makeError,
      )
    }
  } catch {
  | Exn.Error(e) =>
    switch Exn.message(e) {
    | Some(msg) => Lobby.Error(`JS error thrown: ${msg}`->Lobby.makeError)
    | None => Lobby.Error("Some other exception has been thrown"->Lobby.makeError)
    }
  }

  switch val {
  | Data(a) => a
  | Error(e) => Lobby.Error(e)
  }
}

@react.component
let make = (~playerName, ~setPlayerName, ~setXx) => {
  let on_Click = () => {
    open String
    let sanitizedName =
      replaceAllRegExp(playerName, %re("/\W/g"), "")
      ->slice(~start=0, ~end=user_max_len)
      ->padEnd(user_min_len, "_")

    let body = Dict.fromArray([("playerName", JSON.Encode.string(sanitizedName))])

    let zz = fetch("/lobby", JSON.Encode.object(body))->Promise.done

    let p = switch zz {
    | Ok(d) => d
    | Error(e) => e
    }
    setXx(_ => p)
  }

  <Form on_Click>
    <Input value=playerName setFunc=setPlayerName />
  </Form>
}
