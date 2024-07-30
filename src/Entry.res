@react.component
let make = () => {
  
  








  <>
    <div className="bg-opacity-40 bg-black blurred-background">
      <h1 className="ParkLaneNF-font text-center text-6xl bg-gradient-to-t from-orange-400 to-amber-200 text-transparent bg-clip-text">Tessera Iter</h1>
    </div>
      {playerName !== "" && !goIn && <h2 className="text-2xl text-center">Welcome back {playerName}!</h2>}
    <div className="flex portrait:flex-col items-center">
      {playerName !== "" && goIn && <Home playerName={playerName} />}
      {!goIn && playerName === "" && (
        <input
          autoComplete="off"
          autoFocus
          id="inputbox"
          className="h-8"
          onChange={(e) => setInputVal(e.target.value)}
          // ref={inputBox}
          placeholder="enter name"
          spellCheck="false"
          type="text"
          value={inputVal}
        />
      )}
      
      {!goIn && (
        <button
          id="enter"
          className="m-4 bg-gradient-to-t from-orange-400 to-amber-200 w-16 h-8 rounded-sm"
          onClick={() => {
            if (inputVal + playerName === "") {
              return;
            } else if (playerName !== "") {
              setGoIn(true);
            } else if (playerName === "" && inputVal !== "") {
                setGoIn(true);
              setPlayerName(
                inputVal.replace(/\W/g, "").slice(0, NAME_MAX_LENGTH)
              );
            }
          }}
          type="button"
        >
          enter
        </button>
      )}
    </div>
    </>
}
