###
  MongoDB Direct Adapter usability "score chart"

  * Configuration Required: Mongo URL only.
  * Connection Pool Support: Yes.
  * Model Required: Yes.
  * "Class" Methods: Available.
  * "Instance" Methods: Available.
  * Promises and Callbacks Supported: True
  * Use difficulty (0 (easy) to 5 (hard)): 3
  * Flexibility (0 (none) to 5 (ultimate)): 3 
###

require('colors')
mongoose = require 'mongoose'

# JSON to dump in to the DB
user_json = name: "bob", age: 44, status: "D", groups: [ "money" ]
# JSON to update the original json structure with.
update_to = name: "bobo"

module.exports = runner = ->
  new Promise (done, reject) ->
    start = new Date()

    # Create a Model for Mongoose.
    userSchema = new mongoose.Schema
      name: { type: String }
      age: { type: Number }
      status: String
      groups: Array
    MUser = mongoose.model('User', userSchema)

    # Configuration and connection to MongoDB
    mongoose.connect('mongodb://localhost/tempmongoose')
    mongoose.connection.on 'connected', ->
      found_user = null

      checkpoint = new Date()
      console.log "Mongoose started. #{checkpoint - start}ms".cyan

      # Setup the CRUD tests.
      creater = -> 
        new MUser(user_json).save()
      reader = (user) -> 
        MUser.findById(user.id).exec()
      updater = (user) -> 
        console.log JSON.stringify(found_user = user)
        MUser.update({_id: found_user.id}, update_to).exec()
      deleter = (user) -> 
        console.log JSON.stringify(user)
        MUser.remove(_id: user.id).exec()

      # Run the CRUD tests.
      Promise.resolve()
      .then creater
      .then reader
      .then updater
      .then -> MUser.findById(found_user.id).exec()
      .then deleter
      .then -> 
        console.log "Mongoose CRUD completed in #{new Date() - checkpoint}ms (#{new Date() - start}ms total)".cyan
        done()
      .catch reject

runner().catch console.err if !module.parent