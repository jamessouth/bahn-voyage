type t = {
  route: string,
  points: int,
  length: int,
  car1: TrainCard.trainCar,
  car2?: TrainCard.trainCar,
  claimant1: option<Player.t>,
  claimant2?: option<Player.t>,
}
let routes: array<t>
