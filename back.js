import cors from 'cors';
import { config } from 'dotenv';
import express from 'express';
import * as path from 'path';
import Pusher from 'pusher';
import { fileURLToPath } from 'url';
import { playerColors } from './data/colors.js';
import GameState from './state/GameState.js';

const __filename = fileURLToPath(import.meta.url);
const __dirname = path.dirname(__filename);
const MAX_PLAYERS = 5;

//from pusher tutorial
function parseCookies(request) {
  const parsedCookies = {};
  const cookieHeader = request.headers?.cookie;
  if (!cookieHeader) return parsedCookies;
  cookieHeader.split(';').forEach((cookie) => {
    let [name, ...rest] = cookie.split('=');
    name = name?.trim();
    if (!name) return;
    const value = rest.join('=').trim();
    if (!value) return;
    parsedCookies[name] = decodeURIComponent(value);
  });

  return parsedCookies;
}

// this.players[0].name = 'Kappi';
// this.players[1].name = 'Maour';
// this.players[2].name = "Klo"
// this.players[3].name = "Von"
// this.players[4].name = "Skuggi"

let baseState = {};

config(); //dotenv

const pusher = new Pusher({
  appId: process.env.PUSHER_APP_ID,
  key: process.env.PUSHER_APP_KEY,
  secret: process.env.PUSHER_APP_SECRET,
  cluster: process.env.PUSHER_APP_CLUSTER,
  useTLS: true,
});

const app = express();
const port = 8080;
app.use(express.static('./'));
app.use(cors());
app.use(express.urlencoded({ extended: false }));
app.use(express.json());

const playerMap = new Map();
const blockedMap = new Map();

app.post('/pusher/auth', (req, res) => {
  const socketId = req.body.socket_id;

  if (blockedMap.get(socketId)) {
    return;
  } else if (!playerMap.get(socketId) && playerMap.size >= MAX_PLAYERS) {
    blockedMap.set(socketId, 1);
    return res.status(400).send('game is full');
  }

  const channel = req.body.channel_name;
  const cookies = parseCookies(req);

  const { tessera_iter_username } = cookies;

  const authResponse = pusher.authorizeChannel(
    socketId,
    channel,
    tessera_iter_username
  );

  const player = {
    name: tessera_iter_username,
    socketId: socketId,
    color: playerColors[playerMap.size],
  };
  if (playerMap.size === 0) {
    baseState = new GameState(player);
  } else {
    baseState.addPlayer(player);
  }

  if (!playerMap.get(socketId)) {
    playerMap.set(socketId, 1);
  }

  return res.json({
    ...authResponse,
    channel_data: JSON.stringify(tessera_iter_username),
  });
});

app.post('/updatestate', async (req, res) => {
  // const socketId = req.body.socket_id;
  console.log();
  console.log(req.body);
  console.log();
  const pusher_resp = await pusher.trigger(
    'private-totalstate-channel',
    'totalstate-event',
    baseState
  );
  res.sendStatus(pusher_resp.status);
});

app.post('/returndestticket/:socket_id', async (req, res) => {
  const socket_id_body = req.body.socket_id;
  const socket_id_query = req.params.socket_id;
  console.log(socket_id_body === socket_id_query);
  console.log(req.body);
  console.log();
  const pusher_resp = await pusher.trigger(
    `private-${socket_id_body}-channel`,
    'player-event',
    baseState
  );
  res.sendStatus(pusher_resp.status);
});

app.get('/', (req, res) => {
  res.sendFile(path.join(__dirname, '/index.html'));
});

app.use((req, res) => {
  res.status(404).send('error: page not found');
});

app.listen(port, () => {
  console.log(`Example app listening on port ${port}`);
});
