let user_min_len = 3
let user_max_len = 12
let game_code_len = 32

type codeOrNum =
  | None
  | GameCode(string)
  | NumOtherPlayers(string)

let getCodeOrNum = cn =>
  switch cn {
  | None => ""
  | GameCode(gc) => gc
  | NumOtherPlayers(n) => n
  }

@react.component
let make = (~playerName, ~setPlayerName, ~codeOrNum, ~setCodeOrNum, ~setStaging) => {
  let (bodyOrError, setBodyOrError) = React.Uncurried.useState(_ => Form.None)

  let on_Click = () => {
    open String

    let nameTuple = (
      "playerName",
      JSON.Encode.string(
        replaceAllRegExp(playerName, %re("/\W/g"), "")
        ->slice(~start=0, ~end=user_max_len)
        ->padEnd(user_min_len, "_"),
      ),
    )

    switch codeOrNum {
    | None => setBodyOrError(_ => Error("ERROR: " ++ "enter code or number"))
    | GameCode(code) =>
      switch match(code, %re("/^[a-f0-9]{32}$/")) {
      | None => setBodyOrError(_ => Error("ERROR: " ++ "code must be 32 chars long, a-f, 0-9"))
      | Some(_) =>
        let bod = JSON.Encode.object(
          Dict.fromArray([nameTuple, ("gameCode", JSON.Encode.string(code))]),
        )
        setBodyOrError(_ => ReqBody(bod))
        Staging.fetch(bod)
        ->Promise.then(res => {
          Router.push(Router.Staging)
          setStaging(_ => res)->Promise.resolve
        })
        ->Promise.done
      }

    | NumOtherPlayers(num) =>
      switch ["1", "2", "3", "4"]->Array.includes(num) {
      | true =>
        let bod = JSON.Encode.object(
          Dict.fromArray([nameTuple, ("numOtherPlayers", JSON.Encode.string(num))]),
        )
        setBodyOrError(_ => ReqBody(bod))
        Staging.fetch(bod)
        ->Promise.then(res => {
          Router.push(Router.Staging)
          setStaging(_ => res)->Promise.resolve
        })
        ->Promise.done

      | false => setBodyOrError(_ => Error("ERROR: " ++ "num must be 1, 2, 3, or 4"))
      }
    }
  }

  <Form on_Click bodyOrError>
    <Input
      value=playerName
      autoComplete="username"
      placeholder="3-12 letters"
      label="username"
      setFunc=setPlayerName
    />
    <Input
      value={getCodeOrNum(codeOrNum)}
      autoComplete="off"
      placeholder="32-char code or 1-4"
      label="game code or number 1-4"
      setFunc=setCodeOrNum
    />
  </Form>
}
