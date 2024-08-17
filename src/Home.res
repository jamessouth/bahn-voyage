let user_min_len = 3
let user_max_len = 12

@react.component
let make = (~playerName, ~setPlayerName, ~setLobbyGames) => {
  let on_Click = () => {
    open String
    let sanitizedName =
      replaceAllRegExp(playerName, %re("/\W/g"), "")
      ->slice(~start=0, ~end=user_max_len)
      ->padEnd(user_min_len, "_")

    let body = Dict.fromArray([("playerName", JSON.Encode.string(sanitizedName))])

    Lobby.fetch("/lobby", JSON.Encode.object(body), setLobbyGames)->Promise.done
  }

  <Form on_Click>
    <Input value=playerName setFunc=setPlayerName />
  </Form>
}
