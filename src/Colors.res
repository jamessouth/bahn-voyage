type playerColor =
  | @as("#e7bd7f") Peach
  | @as("#e46122") Orange
  | @as("#0a4a6f") Blue
  | @as("#476b52") Green
  | @as("#940403") Red

let playerColors = [Peach, Orange, Blue, Green, Red]

type trainCar =
  | Box
  | Passenger
  | Tanker
  | Reefer
  | Freight
  | Hopper
  | Coal
  | Caboose
  | Locomotive

type trainCardLocation =
  | Hand(string)
  | Deck
  | Table
  | Discard
