let user_min_len = 3
let user_max_len = 12

module Response = {
  type t<'data>
  @send external json: t<'data> => promise<'data> = "json"
}

@val @scope("globalThis")
external fetch: (
  string,
  'params,
) => promise<Response.t<{"a": Nullable.t<string>, "error": Nullable.t<string>}>> = "fetch"

@react.component
let make = (~playerName, ~setPlayerName, ~setXx) => {
  let login = async name => {
    let body = {
      "playerName": name,
    }

    let params = {
      "method": "POST",
      "headers": {
        "Content-Type": "application/json",
      },
      "body": JSON.stringifyAny(body),
    }

    let o = try {
      let response = await fetch("/lobby", params)
      let data = await response->Response.json

      switch Nullable.toOption(data["error"]) {
      | Some(msg) => Error(msg)
      | None =>
        switch Nullable.toOption(data["a"]) {
        | Some(token) =>
          Console.log2("tok", token)
          Ok(token)
        | None => Error("Didn't return a token")
        }
      }
    } catch {
    | _ => Error("Unexpected network error occurred")
    }
    let p = switch o {
    | Ok(d) => d
    | Error(e) => e
    }
    setXx(_ => p)
  }

  let on_Click = () => {
    open String
    let sanitizedName =
      replaceAllRegExp(playerName, %re("/\W/g"), "")
      ->slice(~start=0, ~end=user_max_len)
      ->padEnd(user_min_len, "_")

    login(sanitizedName)->Promise.done
  }

  <Form on_Click>
    <Input value=playerName setFunc=setPlayerName />
  </Form>
}
