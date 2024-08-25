@react.component
let make = (
  ~onClick,
  ~disabled=false,
  ~className="text-black-dk mt-14 bg-white-lt hover:bg-black-lt block max-w-xs lg:max-w-sm text-2xl mx-auto cursor-pointer w-3/5 h-7",
  ~children,
) => {
  <button type_="button" className onClick disabled> {children} </button>
}
