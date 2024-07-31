@react.component
let make = (~on_Click, ~children) => {
  let (submitClicked, setSubmitClicked) = React.Uncurried.useState(_ => false)

  <form className="w-4/5 m-auto relative">
    <fieldset className="flex flex-col items-center justify-around h-72"> {children} </fieldset>
    {switch submitClicked {
    | false => React.null
    | true =>
      <div className="absolute left-1/2 transform -translate-x-2/4 bottom-10">
        <Loading label="..." />
      </div>
    }}
    <Button
      onClick={_ => {
        setSubmitClicked(_ => true)
        on_Click()
      }}>
      {React.string("submit")}
    </Button>
  </form>
}
