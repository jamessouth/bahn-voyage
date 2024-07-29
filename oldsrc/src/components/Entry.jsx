import { useEffect, useState } from 'react';
import { Home } from './Home.jsx';
// import { bgImage } from './entry.jpg';

const nameCookieKey = 'tessera_iter_username=';
const NAME_MAX_LENGTH = 12;

//adapted from mdn document.cookie ex 5
function isCookieSet(key) {
  return document.cookie.split(';').some((k) => k.trim().startsWith(key));
}
function getCookieValue(key) {
  return document.cookie
    .split(';')
    .find((k) => k.trim().startsWith(key))
    .split('=')[1];
}
//adapted from pusher tutorial
function setCookie({ name, value, expiryInDays }) {
  const date = new Date();
  date.setTime(date.getTime() + expiryInDays * 24 * 60 * 60 * 1000);
  const expires = `expires=${date.toUTCString()}`;
  document.cookie = `${name}${value};${expires};path=/;SameSite=Strict`;
}

export const Entry = () => {
  const [inputVal, setInputVal] = useState('');
  const [playerName, setPlayerName] = useState('');
  const [goIn, setGoIn] = useState(false);

  useEffect(() => {
    if (playerName === '') return;
    setCookie({
      name: nameCookieKey,
      value: playerName,
      expiryInDays: 10,
    });
    // setGoIn(true);

  }, [playerName]);

  useEffect(() => {
    if (isCookieSet(nameCookieKey)) {
      console.log('cookie');
      setPlayerName(getCookieValue(nameCookieKey));
    } else {
      console.log('no cookie');
    }
  }, []);

  return (
    <>
    <div className='bg-opacity-40 bg-black blurred-background'>
      <h1 className='ParkLaneNF-font text-center text-6xl bg-gradient-to-t from-orange-400 to-amber-200 text-transparent bg-clip-text'>Tessera Iter</h1>
    </div>
      {playerName !== '' && !goIn && <h2 className='text-2xl text-center'>Welcome back {playerName}!</h2>}
    <div className='flex portrait:flex-col items-center'>
      {playerName !== '' && goIn && <Home playerName={playerName} />}
      {!goIn && playerName === '' && (
        <input
          autoComplete="off"
          autoFocus
          id="inputbox"
          className='h-8'
          onChange={(e) => setInputVal(e.target.value)}
          // ref={inputBox}
          placeholder='enter name'
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
            if (inputVal + playerName === '') {
              return;
            } else if (playerName !== '') {
              setGoIn(true);
            } else if (playerName === '' && inputVal !== '') {
                setGoIn(true);
              setPlayerName(
                inputVal.replace(/\W/g, '').slice(0, NAME_MAX_LENGTH)
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
  );
};
