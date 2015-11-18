require('colors')
MongoClient = require('mongodb').MongoClient

user_json = name: "bob", age: 44, status: "D", groups: [ "money" ]
update_to = name: "bobo"

module.exports = runner = ->

  new Promise (done, reject) ->
    start = new Date()

    MongoClient.connect "mongodb://localhost:27017/tempmongodb", (err, db) ->
      console.log "Direct MongoDB started. #{new Date() - start}ms".cyan
      start = new Date()

      found_user = null
      user = db.collection('user')
      user.insertOne(user_json)
      .then (result) -> user.find(name: user_json.name).toArray()
      .then (users) -> 
        console.log JSON.stringify(found_user = users[0])
        user.updateOne({ _id: found_user._id }, { $set: update_to })
      .then (result) -> user.find(_id: found_user._id).toArray()
      .then (users) -> 
        console.log JSON.stringify(users[0])
        user.deleteOne({_id: found_user._id })
      .then ->
        console.log "Direct MongoDB CRUD completed in #{new Date() - start}ms".cyan
        db.close()
        done()
      .catch reject

runner() if !module.parent