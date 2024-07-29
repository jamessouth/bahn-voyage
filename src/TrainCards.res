

type trainCard = {
  car: Colors.trainCar,
  location: Colors.trainCardLocation,

}



let trainCards = 
  flatMap([Colors.Box, Passenger,Tanker,Reefer,Freight,Hopper,Coal,Caboose,Locomotive], (x) => Array(12).fill(x))
  .concat(Array(2).fill('gray'))
  .map((x) => new TrainCard(x));

