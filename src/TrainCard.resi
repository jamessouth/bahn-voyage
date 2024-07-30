type trainCar = Box | Passenger | Tanker | Reefer | Freight | Hopper | Coal | Caboose | Locomotive
type trainCardLocation = Hand(Player.t) | Deck | Table | Discard
type t = {car: trainCar, location: trainCardLocation}
let trainCards: array<t>
