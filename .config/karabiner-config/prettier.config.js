/** @type {import('prettier').Options} */
module.exports = {
  singleQuote: true,
  trailingComma: 'all',
  bracketSameLine: true,
  printWidth: 100, 
  arrowParens: 'avoid',   // Cleaner: x => x vs (x) => x
  endOfLine: 'lf',
}
