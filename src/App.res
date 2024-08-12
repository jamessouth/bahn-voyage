module LazyLobby = {
  let make = React.lazy_(() => import(Lobby.make))
}
module LazyGame = {
  let make = React.lazy_(() => import(Game.make))
}

@react.component
let make = () => {
  open Router
  let route = useRouter()

  let (playerName, setPlayerName) = React.Uncurried.useState(_ => "")
  let (canEnter, setCanEnter) = React.Uncurried.useState(_ => false)

  let lazyLobby = <LazyLobby playerName />
  let lazyGame = <LazyGame />

  React.useEffect(() => {
    None
  }, [playerName])

  <main className="h-full p-4 flex flex-col items-center justify-around ">
    // lg:p-24

    {switch route {
    | Home => <Entry playerName setPlayerName setCanEnter />
    | Lobby =>
      switch canEnter {
      | true => <React.Suspense fallback=React.null> lazyLobby </React.Suspense>
      | false => React.null
      }

    | Game => <React.Suspense fallback=React.null> lazyGame </React.Suspense>
    | Other => <div className="text-center text-4xl"> {React.string("page not found")} </div>
    }}
  </main>
}
