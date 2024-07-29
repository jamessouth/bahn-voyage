import TrainCard from '../../state/TrainCard.js';
import { cardRouteColors } from '../colors.js';

const trainCards = cardRouteColors
  .flatMap((x) => Array(12).fill(x))
  .concat(Array(2).fill('gray'))
  .map((x) => new TrainCard(x));

export default trainCards;
