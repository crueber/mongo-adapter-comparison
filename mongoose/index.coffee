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
      name: { type: String, lowercase: true}
      age: { type: Number, required: true }
      status: String
      groups: Array
    MUser = mongoose.model('User', userSchema)

    # Get connected to MongoDB, and watch for the connection to open.
    mongoose.connect('mongodb://localhost/tempmongoose')
    mongoose.connection.on 'connected', ->
      found_user = null

      console.log "Mongoose started. #{new Date() - start}ms".cyan
      start = new Date()

      # Alternate: new MUser(user_json).save()
      Promise.resolve()
      .then creater = -> new MUser(user_json).save()
      .then reader = (user) -> MUser.findById(user.id).exec()
      .then updater = (user) -> 
        console.log JSON.stringify(found_user = user)
        MUser.update({_id: found_user.id}, update_to).exec()
      .then -> MUser.findById(found_user.id).exec()
      .then deleter = (user) -> 
        console.log JSON.stringify(user)
        MUser.remove(_id: user.id).exec()
      .then -> 
        console.log "Mongoose CRUD completed in #{new Date() - start}ms".cyan
        done()
      .catch reject

runner().catch console.err if !module.parent