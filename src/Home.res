let user_min_len = 3
let user_max_len = 12
let game_code_len = 32
let other_players_min = 0
let other_players_max = 5

type reqBodyOrError =
  | None
  | ReqBody(dict<'a>)
  | Error(string)

@react.component
let make = (~homeProps as hp, ~setLobby) => {
  let (bodyOrError, setBodyOrError) = React.Uncurried.useState(_ => None)

  let on_Click = () => {
    open String
    let encodedSanitizedName = JSON.Encode.string(
      replaceAllRegExp(hp.playerName, %re("/\W/g"), "")
      ->slice(~start=0, ~end=user_max_len)
      ->padEnd(user_min_len, "_"),
    )

    let reqBodyOrError = switch hp.codeOrNum {
    | None => Error("enter code or number")
    | GameCode(code) =>
      switch match(code, %re("/^[a-f0-9]{32}$/")) {
      | None => Error("code must be 32 chars long, a-f, 0-9")
      | Some(_) =>
        ReqBody(
          Dict.fromArray([
            ("playerName", encodedSanitizedName),
            ("gameCode", JSON.Encode.string(code)),
          ]),
        )
      }
    | NumOtherPlayers(num) =>
      switch num > other_players_min && num < other_players_max {
      | true =>
        ReqBody(
          Dict.fromArray([
            ("playerName", encodedSanitizedName),
            ("numOtherPlayers", JSON.Encode.int(num)),
          ]),
        )
      | false => Error("num must be 1, 2, 3, or 4")
      }
    }

    switch reqBodyOrError {
    | ReqBody(body) => Lobby.fetch(JSON.Encode.object(body))
      ->Promise.then(res => {
        Router.push(Router.Lobby)
        setLobby(_ => res)->Promise.resolve
      })
      ->Promise.done
    | Error(err) => setError(_ => "ERROR: " ++ err)
    }
  }

  <Form on_Click error submitted>
    <Input
      value=hp.playerName
      autoComplete="username"
      placeholder="3-12 letters"
      label="username"
      setFunc=hp.setPlayerName
    />
    <Input
      value=hp.codeOrNum
      autoComplete="off"
      placeholder="32-char code or 1-4"
      label="game code or number 1-4"
      setFunc=hp.setCodeOrNum
    />
  </Form>
}
