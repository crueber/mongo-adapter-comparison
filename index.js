require('coffee-script/register')
require('colors')

m1 = require('./mongodb/index')
m2 = require('./mongoose/index')
m3 = require('./waterline/index')

console.log("Started.")
var start = new Date()

var cl = console.log
console.log = function (msg) { cl("  "+msg); }

var wrapper = function (fn) {
  return new Promise(function (res) {cl('----------'.white); res();})
}

wrapper()
.then(m1)
.then(wrapper)
.then(m2)
.then(wrapper)
.then(m3)
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

