require('colors')
MongoClient = require('mongodb').MongoClient

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

      # Run the CRUD tests.
      creater = -> 
        user.insertOne(user_json)
      reader = (result) -> 
        user.find(name: user_json.name).toArray()
      updater = (users) -> 
        console.log JSON.stringify(found_user = users[0])
        user.updateOne({ _id: found_user._id }, { $set: update_to })
      deleter = (users) -> 
        console.log JSON.stringify(users[0])
        user.deleteOne({_id: found_user._id })

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