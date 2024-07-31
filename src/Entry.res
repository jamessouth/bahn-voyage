let user_min_len = 3
let user_max_len = 12

@react.component
let make = () => {
  let (username, setUsername) = React.Uncurried.useState(_ => "")
  let (canEnter, setCanEnter) = React.Uncurried.useState(_ => false)

  React.useEffect(() => {
    None
  }, [username])

  let on_Click = () => {
    switch (
      String.length(username) < user_min_len || String.length(username) > user_max_len,
      String.match(username, %re("/\W/")),
    ) {
    | (false, None) => setCanEnter(_ => true)

    | (true, _) | (false, Some(_)) => ()
    }
  }
  <>
    <h1 className=" "> {React.string("Bahn Voyage")} </h1>
    {switch canEnter {
    | true => <Lobby />
    | false =>
      <Form on_Click>
        <Input value=username setFunc=setUsername />
      </Form>
    }}
  </>
}
