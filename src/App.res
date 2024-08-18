module LazyGame = {
  let make = React.lazy_(() => import(Game.make))
}

@react.component
let make = () => {
  open Router
  let route = useRouter()

  let (_lobby, _setLobby) = React.Uncurried.useState(_ => Lobby.Loading)

  let (_playerName, _setPlayerName) = React.Uncurried.useState(_ => "")
  //   let (canEnter, setCanEnter) = React.Uncurried.useState(_ => false)

  let lazyGame = <LazyGame />

  //   React.useEffect(() => {
  //     None
  //   }, [playerName])
  //   Console.log2("xxx", lobby)
  <main className="h-full p-4 flex flex-col items-center justify-around ">
    // lg:p-24

    {switch route {
    | Home =>
      <>
        // <Title />
        // <Home playerName setPlayerName setLobby />
        <Lobby />
        // playerName lobby
      </>
    | Lobby => <> </>
    | Game => <React.Suspense fallback=React.null> lazyGame </React.Suspense>
    | Other =>
      <div className="text-center text-4xl bg-orange-100"> {React.string("page not found")} </div>
    }}
  </main>
}
