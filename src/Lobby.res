@react.component
let make = () => {
 
 

  if (pusher_error === '') {
    return (
      <div className="flex flex-col items-center bg-opacity-40 bg-black blurred-background">
        <div className="h-40 mb-4 text-amber-600" id="chat-area">
          name: {playerName}
          <div className="messages"></div>
          <select
            id="actions"
            className="mb-8"
            onChange={(e) => setSelectVal(e.target.value)}
            //  ref={select}
            value={selectVal}
          >
            <option value="enter name">enter name</option>
            <option value="draw train card from deck">
              draw train card from deck
            </option>
            <option value="draw train card from table">
              draw train card from table
            </option>
            <option value="discard dest ticket">discard dest ticket</option>
            <option value="p1">p1</option>
            <option value="p2">p2</option>
          </select>
          <input
            autoComplete="off"
            autoFocus
            className="block border border-black"
            id="inputbox"
            onChange={(e) => setInputVal(e.target.value)}
            // ref={inputBox}
            spellCheck="false"
            type="text"
            value={inputVal}
          />
          <div className="flex justify-around">
            <button
              id="enter"
              className="bg-slate-300 p-1"
              onClick={async () => {
                if (inputVal + selectVal === '') {
                  return;
                }
                if (selectVal === 'discard dest ticket' && inputVal === '') {
                  alert('must input index to discard');
                  return;
                }

                // if (selectVal === 'discard dest ticket' && inputVal !== '') {
                //   const bod = {
                //     message:inputVal,
                //     socket_id,
                //   };

                //   const resp = await fetch('/returndestticket/' + socket_id, {
                //     method: 'POST',
                //     body: JSON.stringify(bod),
                //     headers: {
                //       'Content-Type': 'application/json',
                //     },
                //   });

                //   //   console.log('bd987', resp);
                // }
                console.log(selectVal, inputVal);
              }}
              type="button"
            >
              enter
            </button>
            <button
              onClick={() => {
                const bod = {
                  book_id: 87,
                  fred: true,
                  wilma: 'bart',
                  socket_id,
                };

                fetch('/updatestate', {
                  method: 'POST',
                  body: JSON.stringify(bod),
                  headers: {
                    'Content-Type': 'application/json',
                  },
                });
              }}
              id="trig"
              className="bg-slate-300 p-1"
              type="button"
            >
              trig
            </button>
          </div>
        </div>
        <h2 className='ParkLaneNF-font bg-gradient-to-t from-orange-400 to-amber-200 text-transparent bg-clip-text'>total state</h2>
        <JsonView className="w-90 h-72 bg-offWhite overflow-y-scroll" src={totalstate_data} />
        <h2 className='ParkLaneNF-font bg-gradient-to-t from-orange-400 to-amber-200 text-transparent bg-clip-text'>personal state</h2>
        <JsonView className="w-90 h-72 bg-offWhite overflow-y-scroll" src={player_data} />
      </div>
    );
  } else {
    return <div className='bg-slate-300'>{pusher_error}</div>;
  }
}
