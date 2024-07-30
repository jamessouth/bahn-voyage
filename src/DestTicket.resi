type destTicketLocation = Hand(Player.t) | Deck
type t = {route: string, points: int, location: destTicketLocation}
let destTickets: array<t>
