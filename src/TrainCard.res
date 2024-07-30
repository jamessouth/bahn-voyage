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
  | Hand(Player.t)
  | Deck
  | Table
  | Discard

type t = {
  car: trainCar,
  location: trainCardLocation,
}

let trainCards = [
  {
    car: Box,
    location: Deck,
  },
  {
    car: Box,
    location: Deck,
  },
  {
    car: Box,
    location: Deck,
  },
  {
    car: Box,
    location: Deck,
  },
  {
    car: Box,
    location: Deck,
  },
  {
    car: Box,
    location: Deck,
  },
  {
    car: Box,
    location: Deck,
  },
  {
    car: Box,
    location: Deck,
  },
  {
    car: Box,
    location: Deck,
  },
  {
    car: Box,
    location: Deck,
  },
  {
    car: Box,
    location: Deck,
  },
  {
    car: Box,
    location: Deck,
  },
  {
    car: Passenger,
    location: Deck,
  },
  {
    car: Passenger,
    location: Deck,
  },
  {
    car: Passenger,
    location: Deck,
  },
  {
    car: Passenger,
    location: Deck,
  },
  {
    car: Passenger,
    location: Deck,
  },
  {
    car: Passenger,
    location: Deck,
  },
  {
    car: Passenger,
    location: Deck,
  },
  {
    car: Passenger,
    location: Deck,
  },
  {
    car: Passenger,
    location: Deck,
  },
  {
    car: Passenger,
    location: Deck,
  },
  {
    car: Passenger,
    location: Deck,
  },
  {
    car: Passenger,
    location: Deck,
  },
  {
    car: Tanker,
    location: Deck,
  },
  {
    car: Tanker,
    location: Deck,
  },
  {
    car: Tanker,
    location: Deck,
  },
  {
    car: Tanker,
    location: Deck,
  },
  {
    car: Tanker,
    location: Deck,
  },
  {
    car: Tanker,
    location: Deck,
  },
  {
    car: Tanker,
    location: Deck,
  },
  {
    car: Tanker,
    location: Deck,
  },
  {
    car: Tanker,
    location: Deck,
  },
  {
    car: Tanker,
    location: Deck,
  },
  {
    car: Tanker,
    location: Deck,
  },
  {
    car: Tanker,
    location: Deck,
  },
  {
    car: Reefer,
    location: Deck,
  },
  {
    car: Reefer,
    location: Deck,
  },
  {
    car: Reefer,
    location: Deck,
  },
  {
    car: Reefer,
    location: Deck,
  },
  {
    car: Reefer,
    location: Deck,
  },
  {
    car: Reefer,
    location: Deck,
  },
  {
    car: Reefer,
    location: Deck,
  },
  {
    car: Reefer,
    location: Deck,
  },
  {
    car: Reefer,
    location: Deck,
  },
  {
    car: Reefer,
    location: Deck,
  },
  {
    car: Reefer,
    location: Deck,
  },
  {
    car: Reefer,
    location: Deck,
  },
  {
    car: Freight,
    location: Deck,
  },
  {
    car: Freight,
    location: Deck,
  },
  {
    car: Freight,
    location: Deck,
  },
  {
    car: Freight,
    location: Deck,
  },
  {
    car: Freight,
    location: Deck,
  },
  {
    car: Freight,
    location: Deck,
  },
  {
    car: Freight,
    location: Deck,
  },
  {
    car: Freight,
    location: Deck,
  },
  {
    car: Freight,
    location: Deck,
  },
  {
    car: Freight,
    location: Deck,
  },
  {
    car: Freight,
    location: Deck,
  },
  {
    car: Freight,
    location: Deck,
  },
  {
    car: Hopper,
    location: Deck,
  },
  {
    car: Hopper,
    location: Deck,
  },
  {
    car: Hopper,
    location: Deck,
  },
  {
    car: Hopper,
    location: Deck,
  },
  {
    car: Hopper,
    location: Deck,
  },
  {
    car: Hopper,
    location: Deck,
  },
  {
    car: Hopper,
    location: Deck,
  },
  {
    car: Hopper,
    location: Deck,
  },
  {
    car: Hopper,
    location: Deck,
  },
  {
    car: Hopper,
    location: Deck,
  },
  {
    car: Hopper,
    location: Deck,
  },
  {
    car: Hopper,
    location: Deck,
  },
  {
    car: Coal,
    location: Deck,
  },
  {
    car: Coal,
    location: Deck,
  },
  {
    car: Coal,
    location: Deck,
  },
  {
    car: Coal,
    location: Deck,
  },
  {
    car: Coal,
    location: Deck,
  },
  {
    car: Coal,
    location: Deck,
  },
  {
    car: Coal,
    location: Deck,
  },
  {
    car: Coal,
    location: Deck,
  },
  {
    car: Coal,
    location: Deck,
  },
  {
    car: Coal,
    location: Deck,
  },
  {
    car: Coal,
    location: Deck,
  },
  {
    car: Coal,
    location: Deck,
  },
  {
    car: Caboose,
    location: Deck,
  },
  {
    car: Caboose,
    location: Deck,
  },
  {
    car: Caboose,
    location: Deck,
  },
  {
    car: Caboose,
    location: Deck,
  },
  {
    car: Caboose,
    location: Deck,
  },
  {
    car: Caboose,
    location: Deck,
  },
  {
    car: Caboose,
    location: Deck,
  },
  {
    car: Caboose,
    location: Deck,
  },
  {
    car: Caboose,
    location: Deck,
  },
  {
    car: Caboose,
    location: Deck,
  },
  {
    car: Caboose,
    location: Deck,
  },
  {
    car: Caboose,
    location: Deck,
  },
  {
    car: Locomotive,
    location: Deck,
  },
  {
    car: Locomotive,
    location: Deck,
  },
  {
    car: Locomotive,
    location: Deck,
  },
  {
    car: Locomotive,
    location: Deck,
  },
  {
    car: Locomotive,
    location: Deck,
  },
  {
    car: Locomotive,
    location: Deck,
  },
  {
    car: Locomotive,
    location: Deck,
  },
  {
    car: Locomotive,
    location: Deck,
  },
  {
    car: Locomotive,
    location: Deck,
  },
  {
    car: Locomotive,
    location: Deck,
  },
  {
    car: Locomotive,
    location: Deck,
  },
  {
    car: Locomotive,
    location: Deck,
  },
  {
    car: Locomotive,
    location: Deck,
  },
  {
    car: Locomotive,
    location: Deck,
  },
]
