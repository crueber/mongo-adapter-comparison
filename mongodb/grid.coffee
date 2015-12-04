###
  MongoDB Grid
###

require 'colors'
fs = require 'fs'
path = require 'path'
mongo = require 'mongodb'
MongoClient = mongo.MongoClient
GridFS = require 'gridfs-stream'

file_to_import = path.resolve(__dirname + '/index.coffee')
file_to_export = path.resolve(__dirname + '/index.grid.coffee')
file_name = 'mongodb.adapter.comparison.coffee'

fs.unlinkSync file_to_export if fs.existsSync file_to_export

module.exports = runner = ->
  new Promise (done, reject) ->
    console.log "GridFS test started.".cyan
    MongoClient.connect "mongodb://localhost:27017/tempmongodb", (err, db) ->
      gfs = GridFS(db, mongo)

      start = new Date()
      i = fs.createReadStream file_to_import
      o = gfs.createWriteStream filename: file_name
      i.pipe o
      .on 'error', reject
      .on 'close', (file) ->

        checkpoint = new Date()
        console.log "Pushed #{file_to_import} in #{checkpoint - start}ms.".cyan
        i = gfs.createReadStream _id: file._id
        o = fs.createWriteStream file_to_export
        i.pipe o
        .on 'error', reject
        .on 'close', ->
          console.log "Pulled #{file_name} in #{new Date() - checkpoint}ms (total #{new Date() - start}ms)".cyan
          console.log "#{file_to_export} available."

          gfs.remove {_id: file._id}, (err) ->
            db.close()
            done()

runner().catch console.err if !module.parent
