require('coffee-script/register')
require('colors')

mongodb_test = require('./mongodb/index')
mongoose_test = require('./mongoose/index')
waterline_test = require('./waterline/index')

console.log("Started.")
var start = new Date()

var cl = console.log
console.log = function (msg) { cl("  "+msg); }

var wrapper = function (fn) {
  return new Promise(function (res) {cl('----------'.white); res();})
}

if (!process.argv[2] || process.argv[2] == '--serial'){
  // This is the "Serial" method, to let them all run one at a time. 
  // So they all have the same resources. Most accurate results.
  wrapper()
  .then(mongodb_test)
  .then(wrapper)
  .then(mongoose_test)
  .then(wrapper)
  .then(waterline_test)
  .then(wrapper)
  .then(function() {
    cl(("Complete. " + (new Date - start) + "ms").bgGreen.black)
    process.exit(0)
  })
  .catch(function(e) {
    console.error(e)
    cl(("Error. " + (new Date - start) + "ms").bgRed.white)
    process.exit(1)
  })
}

else if (process.argv[2] && process.argv[2] == '--parallel'){
  // This is the "Asynchronous" way to get them all to connect at the same time.
  Promise.all([mongodb_test(), mongoose_test(), waterline_test()])
  .then(function() {
    cl(("Complete. " + (new Date - start) + "ms").bgGreen.black)
    process.exit(0)
  })
  .catch(function(e) {
    console.error(e)
    cl(("Error. " + (new Date - start) + "ms").bgRed.white)
    process.exit(1)
  })
}

else {
  cl('Wrong switch. --parallel, or --serial.')
}
