type route = {
  ...DestTickets.destTicket,
  length: int,
  color1: string,
  color2: string,
    hasBeenClaimed1: bool,
    hasBeenClaimed2: bool,
}




let arr = [
  { rt: 'Vancouver:Calgary', length: 3, c1: 'gray' },   //0
  { rt: 'Vancouver:Seattle', length: 1, c1: 'gray', c2: 'gray' },
  { rt: 'Seattle:Calgary', length: 4, c1: 'gray' },
  { rt: 'Seattle:Helena', length: 6, c1: 'yellow' },
  { rt: 'Seattle:Portland', length: 1, c1: 'gray', c2: 'gray' },
  { rt: 'Portland:Salt Lake City', length: 6, c1: 'blue' },   //5
  { rt: 'Portland:San Francisco', length: 5, c1: 'green', c2: 'pink' },
  { rt: 'San Francisco:Salt Lake City', length: 5, c1: 'orange', c2: 'white' },
  { rt: 'San Francisco:Los Angeles', length: 3, c1: 'yellow', c2: 'pink' },
  { rt: 'Los Angeles:Las Vegas', length: 2, c1: 'gray' },
  { rt: 'Los Angeles:Phoenix', length: 3, c1: 'gray' },   //10
  { rt: 'Los Angeles:El Paso', length: 6, c1: 'black' },
  { rt: 'Calgary:Winnipeg', length: 6, c1: 'white' },
  { rt: 'Calgary:Helena', length: 4, c1: 'gray' },
  { rt: 'Helena:Winnipeg', length: 4, c1: 'blue' },
  { rt: 'Helena:Salt Lake City', length: 3, c1: 'pink' },   //15
  { rt: 'Helena:Denver', length: 4, c1: 'green' },
  { rt: 'Helena:Duluth', length: 6, c1: 'orange' },
  { rt: 'Helena:Omaha', length: 5, c1: 'red' },
  { rt: 'Salt Lake City:Denver', length: 3, c1: 'red', c2: 'yellow' },
  { rt: 'Las Vegas:Salt Lake City', length: 3, c1: 'orange' },    //20
  { rt: 'Phoenix:Denver', length: 5, c1: 'white' },
  { rt: 'Phoenix:Santa Fe', length: 3, c1: 'gray' },
  { rt: 'Phoenix:El Paso', length: 3, c1: 'gray' },
  { rt: 'Winnipeg:Sault St. Marie', length: 6, c1: 'gray' },
  { rt: 'Winnipeg:Duluth', length: 4, c1: 'black' },    //25
  { rt: 'Duluth:Sault St. Marie', length: 3, c1: 'gray' },
  { rt: 'Duluth:Toronto', length: 6, c1: 'pink' },
  { rt: 'Duluth:Chicago', length: 3, c1: 'red' },
  { rt: 'Duluth:Omaha', length: 2, c1: 'gray', c2: 'gray' },
  { rt: 'Omaha:Chicago', length: 4, c1: 'blue' },   //30
  { rt: 'Omaha:Kansas City', length: 1, c1: 'gray', c2: 'gray' },
  { rt: 'Kansas City:Saint Louis', length: 2, c1: 'blue', c2: 'pink' },
  { rt: 'Kansas City:Oklahoma City', length: 2, c1: 'gray', c2: 'gray' },
  { rt: 'Oklahoma City:Little Rock', length: 2, c1: 'gray' },
  { rt: 'Oklahoma City:Dallas', length: 2, c1: 'gray', c2: 'gray' },    //35
  { rt: 'Dallas:Little Rock', length: 2, c1: 'gray' },
  { rt: 'Dallas:Houston', length: 1, c1: 'gray', c2: 'gray' },
  { rt: 'Houston:New Orleans', length: 2, c1: 'gray' },
  { rt: 'El Paso:Houston', length: 6, c1: 'green' },
  { rt: 'El Paso:Dallas', length: 4, c1: 'red' },   //40
  { rt: 'El Paso:Oklahoma City', length: 5, c1: 'yellow' },
  { rt: 'El Paso:Santa Fe', length: 2, c1: 'gray' },
  { rt: 'Santa Fe:Oklahoma City', length: 3, c1: 'blue' },
  { rt: 'Oklahoma City:Denver', length: 4, c1: 'red' },
  { rt: 'Santa Fe:Denver', length: 2, c1: 'gray' },   //45
  { rt: 'Denver:Kansas City', length: 4, c1: 'black', c2: 'orange' },
  { rt: 'Denver:Omaha', length: 4, c1: 'pink' },
  { rt: 'New Orleans:Miami', length: 6, c1: 'red' },
  { rt: 'New Orleans:Atlanta', length: 4, c1: 'orange', c2: 'yellow' },
  { rt: 'New Orleans:Little Rock', length: 3, c1: 'green' },    //50
  { rt: 'Little Rock:Nashville', length: 3, c1: 'white' },
  { rt: 'Little Rock:Saint Louis', length: 2, c1: 'gray' },
  { rt: 'Saint Louis:Nashville', length: 2, c1: 'gray' },
  { rt: 'Saint Louis:Pittsburgh', length: 5, c1: 'green' },
  { rt: 'Saint Louis:Chicago', length: 2, c1: 'green', c2: 'white' },   //55
  { rt: 'Chicago:Pittsburgh', length: 3, c1: 'black', c2: 'orange' },
  { rt: 'Chicago:Toronto', length: 4, c1: 'white' },
  { rt: 'Sault St. Marie:Montreal', length: 5, c1: 'black' },
  { rt: 'Toronto:Montreal', length: 3, c1: 'gray' },
  { rt: 'Sault St. Marie:Toronto', length: 2, c1: 'gray' },   //60
  { rt: 'Toronto:Pittsburgh', length: 2, c1: 'gray' },
  { rt: 'Pittsburgh:New York', length: 2, c1: 'white', c2: 'green' },
  { rt: 'Pittsburgh:Washington', length: 2, c1: 'gray' },
  { rt: 'Pittsburgh:Raleigh', length: 2, c1: 'gray' },
  { rt: 'Nashville:Raleigh', length: 3, c1: 'black' },    //65
  { rt: 'Nashville:Atlanta', length: 1, c1: 'gray' },
  { rt: 'Nashville:Pittsburgh', length: 4, c1: 'yellow' },
  { rt: 'Atlanta:Miami', length: 5, c1: 'blue' },
  { rt: 'Atlanta:Charleston', length: 2, c1: 'gray' },
  { rt: 'Atlanta:Raleigh', length: 2, c1: 'gray', c2: 'gray' },   //70
  { rt: 'Charleston:Miami', length: 4, c1: 'pink' },
  { rt: 'Raleigh:Charleston', length: 2, c1: 'gray' },
  { rt: 'Raleigh:Washington', length: 2, c1: 'gray', c2: 'gray' },
  { rt: 'Washington:New York', length: 2, c1: 'orange', c2: 'black' },
  { rt: 'New York:Boston', length: 2, c1: 'yellow', c2: 'red' },    //75
  { rt: 'New York:Montreal', length: 3, c1: 'blue' },
  { rt: 'Boston:Montreal', length: 2, c1: 'gray', c2: 'gray' },
];


