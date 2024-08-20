module LazyGame = {
  let make = React.lazy_(() => import(Game.make))
}

@react.component
let make = () => {
  open Router
  let route = useRouter()

  let (staging, setStaging) = React.Uncurried.useState(_ => Staging.Loading)

  let (playerName, setPlayerName) = React.Uncurried.useState(_ => "")
  let (codeOrNum, setCodeOrNum) = React.Uncurried.useState(_ => Home.None)

  let lazyGame = <LazyGame />

  //   React.useEffect(() => {
  //     None
  //   }, [playerName])
  //   Console.log2("xxx", staging)
  <main className="h-full p-4 flex flex-col items-center justify-around ">
    // lg:p-24

    {switch route {
    | Home =>
      <>
        // <Title />
        <Home playerName setPlayerName codeOrNum setCodeOrNum setStaging />
      </>
    | Staging =>
      <>
        <Staging playerName staging />
      </>
    | Game => <React.Suspense fallback=React.null> lazyGame </React.Suspense>
    | Other =>
      <div className="text-center text-4xl bg-orange-100"> {React.string("page not found")} </div>
    }}
  </main>
}
