import destTickets from '../data/destTicket/destTickets.js';
import trainCards from '../data/trainCard/trainCards.js';
import shuffleArray from '../utils/shuffleArray.js';
import Player from './Player.js';

const INIT_DEST_TICKETS = 3;
const INIT_TRAIN_CARDS = 4;
const INIT_TABLE_CARDS = 5;

export default class GameState {

  players = [];
  trainCardDeck = shuffleArray(trainCards);
  trainCardTable = this.trainCardDeck.splice(0, INIT_TABLE_CARDS); //face up cards
  trainCardDiscards = [];
  destTicketDeck = shuffleArray(destTickets);
  isLastRound = false;
  isSmallGame = false;

  constructor(player) {
    //1 player obj with name, socketId, color
    // for (const player of players) {
  

    this.addPlayer(player)
    // }
    this.trainCardTable.forEach((c) => (c.isOnTable = true));
    // if (this.players.length <= 3) {
    //   this.isSmallGame = true;
    // }

    //placeholder names moved to back.js

    //for debugging purposes, prints out the destination and train cards
    // for (let i = 0 ; i < this.destTicketDeck.length; i++) {
    //   console.log(this.destTicketDeck[i])
    // }
    // for (let i = 0; i < this.trainCardDeck.length; i++) {
    //   console.log(this.trainCardDeck[i])
    // }
  }

  addPlayer(player) {
    const trainCards = this.trainCardDeck.splice(0, INIT_TRAIN_CARDS);
    const destTickets = this.destTicketDeck.splice(0, INIT_DEST_TICKETS);
    this.players.push(new Player(player, trainCards, destTickets));
  }

  /**
   * Core game loop method
   */
  runGame() {
    let current = 0; //index of the current player

    //FIXME when one player has two or less trains, everyone including that player should get one more turn. Currently it always ends with last player in order
    while (!this.isLastRound) {
      for (current = 0; current < this.players.length; current++) {
        this.playTurn(current);
        this.isLastRound = this.players[current].numTrains < 3;
        // current %= this.players.length-1  //Should reset current to 0 after the last player in order goes
      }
    }
  }

  /**
   * Method from which a player chooses which action to take
   * 
   * @param {*} current Index of the current player
   */
  playTurn(current) {
    console.log('\n\nIt is ' + this.players[current].name + "'s turn.");
    this.players[current].isTurn = true
    while(this.players[current].isTurn) {
      console.log(
        '[1] Draw train cards\n[2] Claim a route\n[3] Draw destination cards\n'
      );

      //if(input = 1/Draw train cards)
      // this.drawTrainCards(current, 'deck', 'deck')

      //if(input = 2/Claim Route)
      // this.selectRoute(current);

      this.players[current].numTrains = 0; //TEMP
    }
  }

  /**
   * Method for a player to select a route
   *
   * @param {*} current Index of the current player
   * @param {*} r Route the player wants to claim
   * @returns Should return whether the action was valid
   */
  selectRoute(current, r) {
    //Hardcoded value
    let route = r; //routes[0] = { rt: 'Vancouver:Calgary', length: 3, c1: 'gray' }
    let color;
    // switch(current) {
    //   case 0:
    //     route = routes[55];   //{ rt: 'Saint Louis:Chicago', length: 2, c1: 'green', c2: 'white' }
    //     console.log(route.length)
    //     color = 'green';
    //     break;
    //   case 1:
    //     route = routes[55];
    //     color = 'white';
    //     break;
    //   case 2:
    //     route = routes[55];
    //     color = 'white';
    //     break;
    //   default:
    //     route = routes[0];
    //     color = 'red';
    //     break;
    // }
    //select route to claim
    console.log(route.name);
    //(One lane, route claimed) or (Small game, route claimed) or (both routes claimed)
    if (
      (route.taken1 && route.color2 === null) ||
      (this.isSmallGame && (route.taken1 || route.taken2)) ||
      (route.taken1 && route.taken2)
    ) {
      console.log('Route already claimed!');
      return;
    }

    //any gray double routes are gray on both routes
    if (route.color1 === 'gray') {
      console.log('Which color do you want to play this route as?');
      // get player input
      // color = input color
      // color = 'blue';
    } else if (
      route.color1 !== 'gray' &&
      route.color2 !== null &&
      !(route.taken1 || route.taken2)
    ) {
      console.log('Which color of the route do you want to claim?');
      console.log(
        'Attempting to claim the ' + color + ' route of ' + route.name
      );
    } else if (route.taken1) {
      color = route.color2;
    } else if (route.taken2) {
      color = route.color1;
    }

    console.log('Attempting to claim the ' + color + ' route of ' + route.name);
    if (
      color !== route.color1 &&
      color !== route.color2 &&
      route.color1 !== 'gray'
    ) {
      console.log('Cannot claim that route with that color!');
      return;
    }
    //player chooses color before the claim route method. If the route is gray, choose color they're playing before this method
    this.trainCardDiscards.concat(
      this.players[current].claimRoute(route, color)
    );
  }

  /**
   * Method for a player to draw train cards
   * 
   * @param current Index of the current player
   * @param color1 Color of the first card drawn if drawing from the face up cards, 'deck' if drawing from the deck
   * @param color2 Color of the second card drawn if drawing from the face up cards, 'deck if drawing from the deck. Must not be allowed to be 'gray'
   * @returns Should return a boolean reflecting whether player's turn is finished
   */
  drawTrainCards(current, color1, color2) {
    if (!this.players[current].isTurn) {
      return;
    }

    let firstCardDrawn = false
    // let secondCardDrawn = false
    while(this.players[current].trainCardsLeftToDrawThisTurn > 0) {

      //empty deck case (rare)
      if (this.trainCardDeck.length === 0 && this.trainCardDiscards.length === 0) {
        console.log("empty deck");
        //need to force the player to take another action
        return false;
      } else if (this.trainCardDeck.length === 0) {
        this.trainCardDeck = shuffleArray(this.trainCardDiscards)
      }
      if (!firstCardDrawn) {
        if (color1 === 'deck'){
          //if the first card is from the deck
          const card = this.trainCardDeck.pop();
          this.players[current].trainCards.push(card);
          this.players[current].trainCardsLeftToDrawThisTurn -= 1
          firstCardDrawn = true
        } else {
          //if the first card is from the face-up
          for (let i = 0; i < 5; i++) {
            let currentCard = this.trainCardTable[i]
            if (currentCard.color === color1) {
              if (currentCard.color === 'gray') {
                this.players[current].trainCardsLeftToDrawThisTurn -= 2
                this.players[current].trainCards.push(currentCard)
                this.trainCardTable.splice(i, 1, this.trainCardDeck.pop())
                this.players[current].isTurn = false;
                return true;
              } else {
                this.players[current].trainCardsLeftToDrawThisTurn -= 1
                firstCardDrawn = true
              }
              this.players[current].trainCards.push(currentCard)
              this.trainCardTable.splice(i, 1, this.trainCardDeck.pop())
              break;
            }
          }
        }
      }
      console.log(this.players[current].trainCardsLeftToDrawThisTurn)
      
      //if the second card is from the deck
      //FIXME account for empty deck case (rare)
      if (color2 === 'deck') {
        const card = this.trainCardDeck.pop();
        this.players[current].trainCards.push(card);
        this.players[current].trainCardsLeftToDrawThisTurn -= 1
      } else {
        //if the second card is from the face-up
        for (let i = 0; i < 5; i++) {
          let currentCard = this.trainCardTable[i]
          if (currentCard.color === color2) {
            if (currentCard.color === 'gray') {
              console.log("Cannot claim a face-up wild as your second card!")
              return false;
            } else {
              this.players[current].trainCardsLeftToDrawThisTurn -= 1
            }
            this.players[current].trainCards.push(currentCard)
            this.trainCardTable.splice(i, 1, this.trainCardDeck.pop())
            break;
          }
        }
      }
    }
    this.players[current].isTurn = false
  }


}
