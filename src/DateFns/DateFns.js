export {
  formatDuration as _formatDuration,
  intervalToDuration as _intervalToDuration,
  intlFormatDistance as _intlFormatDistance,
  parse as _parse,
  parseJSON as _parseJSON
} from 'date-fns'

export function _toDate(instant) {
  return new Date(instant);
}


/**
 * 
 * @param {Date} date 
 */
export function _toInstant(date) {
  return date.getTime();
}

/**
 * 
 * @param {Date} date 
 */
export function _showDate(date) {
  return date.toISOString();
}
