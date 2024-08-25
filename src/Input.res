@react.component
let make = (~value, ~autoComplete, ~placeholder, ~fontSize, ~label, ~setFunc) => {
  let onChange = e => setFunc(_ => ReactEvent.Form.target(e)["value"])

  <div className="max-w-xs lg:max-w-sm w-full">
    <label className="text-2xl font-flow text-stone-100" htmlFor=label>
      {React.string(label)}
    </label>
    <input
      autoComplete
      className={`h-6 w-full ${fontSize} outline-none indent-0.5 bg-white-lt text-black-dk `}
      id=label
      inputMode="text"
      onChange
      onKeyPress={_e => ()}
      placeholder
      spellCheck=false
      type_="text"
      value
    />
  </div>
}
