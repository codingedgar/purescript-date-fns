export {
  intlFormatDistance as intlFormatDistanceImp,
  formatDuration as formatDurationImp,
} from 'date-fns'

export function toDateImpl(instant) {
  return new Date(instant);
}

/**
 * 
 * @param {Date} date 
 */
export function showDateImpl(date) {
  return date.toISOString();
}
