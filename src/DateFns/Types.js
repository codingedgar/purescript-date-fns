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
