@val external parseInt: string => int = "parseInt"
let user_min_len = 3
let user_max_len = 12

type codeOrNum =
  | None
  | GameCode(string)
  | NumOtherPlayers(string)

@react.component
let make = (
  ~playerName,
  ~setPlayerName,
  ~codeOrNum,
  ~setCodeOrNum,
  ~codeOrNumString,
  ~setCodeOrNumString,
  ~setStaging,
) => {
  let (bodyOrError, setBodyOrError) = React.Uncurried.useState(_ => Form.None)
  let isMounted = React.useRef(false)

  React.useEffect1(() => {
    open String

    if isMounted.current {
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
            Dict.fromArray([nameTuple, ("numOtherPlayers", JSON.Encode.int(parseInt(num)))]),
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
    } else {
      ()
      isMounted.current = true
    }

    None
  }, [codeOrNum])

  let on_Click = () => {
    setCodeOrNum(_ =>
      switch String.length(codeOrNumString) == 1 {
      | true => NumOtherPlayers(codeOrNumString)
      | false =>
        switch String.length(codeOrNumString) == 0 {
        | true => None
        | false => GameCode(codeOrNumString)
        }
      }
    )
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
      value=codeOrNumString
      autoComplete="off"
      placeholder="32-char code or 1-4"
      label="game code or number 1-4"
      setFunc=setCodeOrNumString
    />
  </Form>
}
