@react.component
let make = (~value, ~setFunc) => {
  let onChange = e => setFunc(_ => ReactEvent.Form.target(e)["value"])

  <div className="max-w-xs lg:max-w-sm w-full">
    <label className="text-2xl font-flow text-stone-100" htmlFor="username">
      {React.string("username")}
    </label>
    <input
      autoComplete="username"
      className="h-6 w-full text-xl outline-none font-anon bg-white border-b-1 text-stone-900 border-stone-100 indent-2px"
      id="username"
      inputMode="text"
      onChange
      onKeyPress={_e => ()}
      spellCheck=false
      type_="text"
      value
    />
  </div>
}
