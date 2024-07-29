import Pusher from 'pusher-js';
import { useEffect, useState } from 'react';
import JsonView from 'react18-json-view';
import 'react18-json-view/src/style.css';

// from pusher tutorial
function getPusherClient() {
  Pusher.logToConsole = true;
  return new Pusher('fe257281aabc7cebb6f2', { cluster: 'us2' });
}

export const Home = ({ playerName }) => {
  // const inputBox = useRef(null);
  // const select = useRef(null);

  const [inputVal, setInputVal] = useState('');
  const [selectVal, setSelectVal] = useState('');
  const [pusher, setPusher] = useState(null);
  const [socket_id, setSocket_id] = useState(null);
  const [totalstate_channel, setTotalstate_channel] = useState(null);
  const [player_channel, setPlayer_channel] = useState(null);
  const [totalstate_data, setTotalstate_data] = useState({});
  const [player_data, setPlayer_data] = useState({});
  const [pusher_error, setPusher_error] = useState('');

  useEffect(() => {
    setPusher(getPusherClient());
  }, []);

  useEffect(() => {
    if (pusher !== null) {
      pusher.connection.bind('connected', () => {
        setSocket_id(pusher.connection.socket_id);
      });
    }
  }, [pusher]);

  useEffect(() => {
    if (pusher !== null && socket_id !== null) {
      setTotalstate_channel(pusher.subscribe('private-totalstate-channel'));
      setPlayer_channel(pusher.subscribe(`private-${socket_id}-channel`));
    }
  }, [pusher, socket_id]);

  useEffect(() => {
    if (totalstate_channel !== null) {
      totalstate_channel.bind('pusher:subscription_error', (err) => {
        setPusher_error(err.error);
        console.log(err);
      });

      totalstate_channel.bind('totalstate-event', (data) => {
        if (data) {
          // document.querySelector('#json').data = data;
          setTotalstate_data(data);
        }
      });
    }

    if (player_channel !== null) {
      player_channel.bind('pusher:subscription_error', (err) => {
        setPusher_error(err.error);
        console.log(err);
      });
      player_channel.bind('player-event', (data) => {
        if (data) {
          // document.querySelector('#json2').data = data;
          setPlayer_data(data);
        }
      });
    }
  }, [player_channel, totalstate_channel]);

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
};
