
export default class Route {

  isSmallGame = true;
  name = '';
  points = 0;
  length = 0;
  color1 = '';
  color2 = '';
  taken1 = false;
  taken2 = false;

  constructor(name, length, color1, color2 = null) {
    this.name = name;
    this.length = length;
    this.color1 = color1;
    this.color2 = color2;

    //Sets the points
    switch(length){
      case 1:
        this.points = 1
        break
      case 2:
        this.points = 2
        break
      case 3:
        this.points = 4
        break
      case 4: 
        this.points = 7
        break
      case 5:
        this.points = 10
        break
      case 6:
        this.points = 15
        break
    }
  }
}
