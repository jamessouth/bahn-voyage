type destTicketLocation =
  | Hand(Player.t)
  | Deck

type t = {
  route: string,
  points: int,
  location: destTicketLocation,
}

let destTickets = [
  {route: "Boston:Miami", points: 12, location: Deck},
  {route: "Calgary:Phoenix", points: 13, location: Deck},
  {route: "Calgary:Salt Lake City", points: 7, location: Deck},
  {route: "Chicago:New Orleans", points: 7, location: Deck},
  {route: "Chicago:Santa Fe", points: 9, location: Deck},
  {route: "Dallas:New York", points: 11, location: Deck},
  {route: "Denver:El Paso", points: 4, location: Deck},
  {route: "Denver:Pittsburgh", points: 11, location: Deck},
  {route: "Duluth:El Paso", points: 10, location: Deck},
  {route: "Duluth:Houston", points: 8, location: Deck},
  {route: "Helena:Los Angeles", points: 8, location: Deck},
  {route: "Kansas City:Houston", points: 5, location: Deck},
  {route: "Los Angeles:Chicago", points: 16, location: Deck},
  {route: "Los Angeles:Miami", points: 20, location: Deck},
  {route: "Los Angeles:New York", points: 21, location: Deck},
  {route: "Montréal:Atlanta", points: 9, location: Deck},
  {route: "Montréal:New Orleans", points: 13, location: Deck},
  {route: "New York:Atlanta", points: 6, location: Deck},
  {route: "Portland:Nashville", points: 17, location: Deck},
  {route: "Portland:Phoenix", points: 11, location: Deck},
  {route: "San Francisco:Atlanta", points: 17, location: Deck},
  {route: "Sault St. Marie:Nashville", points: 8, location: Deck},
  {route: "Sault St. Marie:Oklahoma City", points: 9, location: Deck},
  {route: "Seattle:Los Angeles", points: 9, location: Deck},
  {route: "Seattle:New York", points: 22, location: Deck},
  {route: "Toronto:Miami", points: 10, location: Deck},
  {route: "Vancouver:Montréal", points: 20, location: Deck},
  {route: "Vancouver:Santa Fe", points: 13, location: Deck},
  {route: "Winnipeg:Houston", points: 12, location: Deck},
  {route: "Winnipeg:Little Rock", points: 11, location: Deck},
]
