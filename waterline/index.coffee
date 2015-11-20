require('colors')
Waterline = require 'waterline'
sailsmongo = require 'sails-mongo'

# JSON to dump in to the DB
user_json = name: "bob", age: 44, status: "D", groups: [ "money" ]
# JSON to update the original json structure with.
update_to = name: "bobo"

module.exports = runner = ->
  new Promise (done, reject) ->
    start = new Date()

    # General configuraiton for Waterline.
    waterline_config = 
      connections:
        mongo: 
          adapter: 'sails-mongo'
          url: 'mongodb://localhost/tempwaterline'
      adapters: { "sails-mongo": sailsmongo }
    waterline = new Waterline()

    # Create a model for our Waterline adapter.
    WUser = Waterline.Collection.extend
      tableName: 'users'
      identity: 'user'
      schema: false
      connection: 'mongo'
      autoCreatedAt: false
      autoUpdatedAt: false
      attributes:
        name: { type: 'string', required: true }
        age: { type: 'integer', required: true }
        status: { type: 'string', required: true }
        groups: { type: 'array' }
    waterline.loadCollection WUser

    # Open the connection to the defined database.
    waterline.initialize waterline_config, (err, db) ->
      reject(err) if err
      WUser = db.collections.user

      checkpoint = new Date()
      console.log "Waterline connected. #{checkpoint - start}ms".cyan

      # Setup the CRUD tests.
      found_user = null
      creater =  -> WUser.create(user_json)
      reader = (user) -> WUser.findOne().where(id: user.id)
      updater = (user) -> 
        console.log JSON.stringify(user)
        WUser.update({id: user.id}, update_to)
      deleter = (users) -> 
        console.log JSON.stringify(users[0])
        WUser.destroy(id: users[0].id)

      # Run the CRUD tests.
      Promise.resolve()
      .then creater
      .then reader
      .then updater
      .then deleter
      .then ->
        console.log "Waterline CRUD completed in #{new Date() - checkpoint}ms (#{new Date() - start}ms total)".cyan
        done()
      .catch reject

runner().catch console.err if !module.parent