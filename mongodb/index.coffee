###
  MongoDB Direct Adapter usability "score chart"

  * Configuration Required: Mongo URL only.
  * Connection Pool Support: No.
  * Model Required: No.
  * "Class" Methods: No model. Unavailable from library. Would need Backbone.Model or something similar.
  * "Instance" Methods: No model. Unavailable from library. Would need Backbone.Model or something similar.
  * Promises and Callbacks Supported: True
  * Use difficulty (0 (easy) to 5 (hard)): 2
  * Flexibility (0 (none) to 5 (ultimate)): 4
###

require 'colors'
{MongoClient} = require 'mongodb'

# JSON to dump in to the DB
user_json = name: "bob", age: 44, status: "D", groups: [ "money" ]
# JSON to update the original json structure with.
update_to = name: "bobo"

module.exports = runner = ->

  new Promise (done, reject) ->
    start = new Date()

    # Configuration and connection to Mongo. No Models.
    MongoClient.connect "mongodb://localhost:27017/tempmongodb", (err, db) ->
      checkpoint = new Date()
      console.log "Direct MongoDB started. #{checkpoint - start}ms".cyan

      found_user = null
      user = db.collection('user')

      # Setup the CRUD tests.
      creater = ->  user.insertOne(user_json)
      reader = (result) -> 
        user.find(name: user_json.name).toArray()
      updater = (users) -> 
        console.log JSON.stringify(found_user = users[0])
        user.updateOne({ _id: found_user._id }, { $set: update_to })
      deleter = (users) -> 
        console.log JSON.stringify(users[0])
        user.deleteOne({_id: found_user._id })

      # Run the CRUD tests.
      Promise.resolve()
      .then creater
      .then reader
      .then updater
      .then (result) -> user.find(_id: found_user._id).toArray()
      .then deleter
      .then ->
        console.log "Direct MongoDB CRUD completed in #{new Date() - checkpoint}ms (#{new Date() - start}ms total)".cyan
        db.close()
        done()
      .catch reject

runner().catch console.err if !module.parent
