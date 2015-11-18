require('colors')
Waterline = require 'waterline'
sailsmongo = require 'sails-mongo'

user_json = name: "bob", age: 44, status: "D", groups: [ "money" ]
update_to = name: "bobo"

module.exports = runner = ->
  new Promise (done, reject) ->
    start = new Date()
    waterline_config = 
      connections:
        mongo: 
          adapter: 'sails-mongo'
          url: 'mongodb://localhost/tempwaterline'
      adapters: { "sails-mongo": sailsmongo }

    waterline = new Waterline()
    WUser = Waterline.Collection.extend
      tableName: 'users'
      identity: 'user'
      schema: true
      connection: 'mongo'
      autoCreatedAt: false
      autoUpdatedAt: false
      attributes:
        name: { type: 'string', required: true }
        age: { type: 'integer', required: true, min: 18 }
        status: { type: 'string', required: true }
        groups: { type: 'array' }
    waterline.loadCollection WUser

    waterline.initialize waterline_config, (err, db) ->
      reject(err) if err
      WUser = db.collections.user

      console.log "Waterline connected. #{new Date() - start}ms".cyan
      start = new Date()

      found_user = null
      creater = WUser.create(user_json)
      .then reader = (user) -> WUser.findOne().where(id: user.id)
      .then updater = (user) -> 
        console.log JSON.stringify(user)
        WUser.update({id: user.id}, update_to)
      .then deleter = (users) -> 
        console.log JSON.stringify(users[0])
        WUser.destroy(id: users[0].id)
      .then ->
        console.log "Waterline CRUD completed in #{new Date() - start}ms".cyan
        done()
      .catch reject

runner() if !module.parent