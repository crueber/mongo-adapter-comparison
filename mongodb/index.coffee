require('colors')
MongoClient = require('mongodb').MongoClient

# JSON to dump in to the DB
user_json = name: "bob", age: 44, status: "D", groups: [ "money" ]
# JSON to update the original json structure with.
update_to = name: "bobo"

module.exports = runner = ->

  new Promise (done, reject) ->
    start = new Date()

    # Connect to Mongo. No Models.
    MongoClient.connect "mongodb://localhost:27017/tempmongodb", (err, db) ->
      console.log "Direct MongoDB started. #{new Date() - start}ms".cyan
      start = new Date()

      found_user = null
      user = db.collection('user')
      creater = user.insertOne(user_json)
      .then reader = (result) -> user.find(name: user_json.name).toArray()
      .then updater = (users) -> 
        console.log JSON.stringify(found_user = users[0])
        user.updateOne({ _id: found_user._id }, { $set: update_to })
      .then (result) -> user.find(_id: found_user._id).toArray()
      .then deleter = (users) -> 
        console.log JSON.stringify(users[0])
        user.deleteOne({_id: found_user._id })
      .then ->
        console.log "Direct MongoDB CRUD completed in #{new Date() - start}ms".cyan
        db.close()
        done()
      .catch reject

runner() if !module.parent