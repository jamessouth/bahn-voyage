type reqBodyOrError =
  | None
  | ReqBody(RescriptCore.JSON.t)
  | Error(string)

@react.component
let make = (~on_Click, ~bodyOrError, ~children) => {
  <form className="w-4/5 m-auto relative">
    <fieldset className="flex flex-col items-center justify-around h-72"> {children} </fieldset>
    <div className="absolute left-1/2 transform -translate-x-2/4 bottom-10">
      {switch bodyOrError {
      | None => React.null
      | ReqBody(_) => <Loading label="..." />
      | Error(err) => <p> {React.string(err)} </p>
      }}
    </div>
    <Button
      onClick={_ => {
        on_Click()
      }}>
      {React.string("submit")}
    </Button>
  </form>
}
