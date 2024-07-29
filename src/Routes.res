type route = {
  route: string,
  points: int,
  length: int,
  color1: string,
  color2: string,
  firstClaimant: string,
}

let routes = [
  {route: "Vancouver:Calgary", points: 4, length: 3, color1: "gray", firstClaimant: ""},
  {
    route: "Vancouver:Seattle",
    points: 1,
    length: 1,
    color1: "gray",
    color2: "gray",
    firstClaimant: "",
  },
  {route: "Seattle:Calgary", points: 7, length: 4, color1: "gray", firstClaimant: ""},
  {route: "Seattle:Helena", points: 15, length: 6, color1: "yellow", firstClaimant: ""},
  {
    route: "Seattle:Portland",
    points: 1,
    length: 1,
    color1: "gray",
    color2: "gray",
    firstClaimant: "",
  },
  {route: "Portland:Salt Lake City", points: 15, length: 6, color1: "blue", firstClaimant: ""},
  {
    route: "Portland:San Francisco",
    points: 10,
    length: 5,
    color1: "green",
    color2: "pink",
    firstClaimant: "",
  },
  {
    route: "San Francisco:Salt Lake City",
    points: 10,
    length: 5,
    color1: "orange",
    color2: "white",
    firstClaimant: "",
  },
  {
    route: "San Francisco:Los Angeles",
    points: 4,
    length: 3,
    color1: "yellow",
    color2: "pink",
    firstClaimant: "",
  },
  {route: "Los Angeles:Las Vegas", points: 2, length: 2, color1: "gray", firstClaimant: ""},
  {route: "Los Angeles:Phoenix", points: 4, length: 3, color1: "gray", firstClaimant: ""},
  {route: "Los Angeles:El Paso", points: 15, length: 6, color1: "black", firstClaimant: ""},
  {route: "Calgary:Winnipeg", points: 15, length: 6, color1: "white", firstClaimant: ""},
  {route: "Calgary:Helena", points: 7, length: 4, color1: "gray", firstClaimant: ""},
  {route: "Helena:Winnipeg", points: 7, length: 4, color1: "blue", firstClaimant: ""},
  {route: "Helena:Salt Lake City", points: 4, length: 3, color1: "pink", firstClaimant: ""},
  {route: "Helena:Denver", points: 7, length: 4, color1: "green", firstClaimant: ""},
  {route: "Helena:Duluth", points: 15, length: 6, color1: "orange", firstClaimant: ""},
  {route: "Helena:Omaha", points: 10, length: 5, color1: "red", firstClaimant: ""},
  {
    route: "Salt Lake City:Denver",
    points: 4,
    length: 3,
    color1: "red",
    color2: "yellow",
    firstClaimant: "",
  },
  {route: "Las Vegas:Salt Lake City", points: 4, length: 3, color1: "orange", firstClaimant: ""},
  {route: "Phoenix:Denver", points: 10, length: 5, color1: "white", firstClaimant: ""},
  {route: "Phoenix:Santa Fe", points: 4, length: 3, color1: "gray", firstClaimant: ""},
  {route: "Phoenix:El Paso", points: 4, length: 3, color1: "gray", firstClaimant: ""},
  {route: "Winnipeg:Sault St. Marie", points: 15, length: 6, color1: "gray", firstClaimant: ""},
  {route: "Winnipeg:Duluth", points: 7, length: 4, color1: "black", firstClaimant: ""},
  {route: "Duluth:Sault St. Marie", points: 4, length: 3, color1: "gray", firstClaimant: ""},
  {route: "Duluth:Toronto", points: 15, length: 6, color1: "pink", firstClaimant: ""},
  {route: "Duluth:Chicago", points: 4, length: 3, color1: "red", firstClaimant: ""},
  {route: "Duluth:Omaha", points: 2, length: 2, color1: "gray", color2: "gray", firstClaimant: ""},
  {route: "Omaha:Chicago", points: 7, length: 4, color1: "blue", firstClaimant: ""},
  {
    route: "Omaha:Kansas City",
    points: 1,
    length: 1,
    color1: "gray",
    color2: "gray",
    firstClaimant: "",
  },
  {
    route: "Kansas City:Saint Louis",
    points: 2,
    length: 2,
    color1: "blue",
    color2: "pink",
    firstClaimant: "",
  },
  {
    route: "Kansas City:Oklahoma City",
    points: 2,
    length: 2,
    color1: "gray",
    color2: "gray",
    firstClaimant: "",
  },
  {route: "Oklahoma City:Little Rock", points: 2, length: 2, color1: "gray", firstClaimant: ""},
  {
    route: "Oklahoma City:Dallas",
    points: 2,
    length: 2,
    color1: "gray",
    color2: "gray",
    firstClaimant: "",
  },
  {route: "Dallas:Little Rock", points: 2, length: 2, color1: "gray", firstClaimant: ""},
  {
    route: "Dallas:Houston",
    points: 1,
    length: 1,
    color1: "gray",
    color2: "gray",
    firstClaimant: "",
  },
  {route: "Houston:New Orleans", points: 2, length: 2, color1: "gray", firstClaimant: ""},
  {route: "El Paso:Houston", points: 15, length: 6, color1: "green", firstClaimant: ""},
  {route: "El Paso:Dallas", points: 7, length: 4, color1: "red", firstClaimant: ""},
  {route: "El Paso:Oklahoma City", points: 10, length: 5, color1: "yellow", firstClaimant: ""},
  {route: "El Paso:Santa Fe", points: 2, length: 2, color1: "gray", firstClaimant: ""},
  {route: "Santa Fe:Oklahoma City", points: 4, length: 3, color1: "blue", firstClaimant: ""},
  {route: "Oklahoma City:Denver", points: 7, length: 4, color1: "red", firstClaimant: ""},
  {route: "Santa Fe:Denver", points: 2, length: 2, color1: "gray", firstClaimant: ""},
  {
    route: "Denver:Kansas City",
    points: 7,
    length: 4,
    color1: "black",
    color2: "orange",
    firstClaimant: "",
  },
  {route: "Denver:Omaha", points: 7, length: 4, color1: "pink", firstClaimant: ""},
  {route: "New Orleans:Miami", points: 15, length: 6, color1: "red", firstClaimant: ""},
  {
    route: "New Orleans:Atlanta",
    points: 7,
    length: 4,
    color1: "orange",
    color2: "yellow",
    firstClaimant: "",
  },
  {route: "New Orleans:Little Rock", points: 4, length: 3, color1: "green", firstClaimant: ""},
  {route: "Little Rock:Nashville", points: 4, length: 3, color1: "white", firstClaimant: ""},
  {route: "Little Rock:Saint Louis", points: 2, length: 2, color1: "gray", firstClaimant: ""},
  {route: "Saint Louis:Nashville", points: 2, length: 2, color1: "gray", firstClaimant: ""},
  {route: "Saint Louis:Pittsburgh", points: 10, length: 5, color1: "green", firstClaimant: ""},
  {
    route: "Saint Louis:Chicago",
    points: 2,
    length: 2,
    color1: "green",
    color2: "white",
    firstClaimant: "",
  },
  {
    route: "Chicago:Pittsburgh",
    points: 4,
    length: 3,
    color1: "black",
    color2: "orange",
    firstClaimant: "",
  },
  {route: "Chicago:Toronto", points: 7, length: 4, color1: "white", firstClaimant: ""},
  {route: "Sault St. Marie:Montreal", points: 10, length: 5, color1: "black", firstClaimant: ""},
  {route: "Toronto:Montreal", points: 4, length: 3, color1: "gray", firstClaimant: ""},
  {route: "Sault St. Marie:Toronto", points: 2, length: 2, color1: "gray", firstClaimant: ""},
  {route: "Toronto:Pittsburgh", points: 2, length: 2, color1: "gray", firstClaimant: ""},
  {
    route: "Pittsburgh:New York",
    points: 2,
    length: 2,
    color1: "white",
    color2: "green",
    firstClaimant: "",
  },
  {route: "Pittsburgh:Washington", points: 2, length: 2, color1: "gray", firstClaimant: ""},
  {route: "Pittsburgh:Raleigh", points: 2, length: 2, color1: "gray", firstClaimant: ""},
  {route: "Nashville:Raleigh", points: 4, length: 3, color1: "black", firstClaimant: ""},
  {route: "Nashville:Atlanta", points: 1, length: 1, color1: "gray", firstClaimant: ""},
  {route: "Nashville:Pittsburgh", points: 7, length: 4, color1: "yellow", firstClaimant: ""},
  {route: "Atlanta:Miami", points: 10, length: 5, color1: "blue", firstClaimant: ""},
  {route: "Atlanta:Charleston", points: 2, length: 2, color1: "gray", firstClaimant: ""},
  {
    route: "Atlanta:Raleigh",
    points: 2,
    length: 2,
    color1: "gray",
    color2: "gray",
    firstClaimant: "",
  },
  {route: "Charleston:Miami", points: 7, length: 4, color1: "pink", firstClaimant: ""},
  {route: "Raleigh:Charleston", points: 2, length: 2, color1: "gray", firstClaimant: ""},
  {
    route: "Raleigh:Washington",
    points: 2,
    length: 2,
    color1: "gray",
    color2: "gray",
    firstClaimant: "",
  },
  {
    route: "Washington:New York",
    points: 2,
    length: 2,
    color1: "orange",
    color2: "black",
    firstClaimant: "",
  },
  {
    route: "New York:Boston",
    points: 2,
    length: 2,
    color1: "yellow",
    color2: "red",
    firstClaimant: "",
  },
  {route: "New York:Montreal", points: 4, length: 3, color1: "blue", firstClaimant: ""},
  {
    route: "Boston:Montreal",
    points: 2,
    length: 2,
    color1: "gray",
    color2: "gray",
    firstClaimant: "",
  },
]
