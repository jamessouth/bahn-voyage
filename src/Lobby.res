@react.component
let make = (~playerName) => {
  <div> {React.string(`this is the lobby ${playerName}`)} </div>
}
