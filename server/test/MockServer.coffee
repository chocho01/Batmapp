require('coffee-script/register');
process.env.NODE_ENV = "test"

express = require('express')
config = require('../config/config')
glob = require('glob')
md5 = require('md5')
mongoose = require('mongoose')

mongoose.connect(config.db)

db = mongoose.connection
db.on 'error', ()->
  throw new Error('unable to connect to database at ' + config.db)


models = glob.sync(config.root + '/app/models/*.coffee')
models.forEach (model)->
  require(model)

#UserModel = mongoose.model('user')
#user = new UserModel
#  email : "martin.choraine@epsi.fr"
#  password : md5("martin")
#  lastName : "Choraine"
#  firstName : "Martin"
#user.save (err)->
#  console.log(err)

app = express()

require('../config/express')(app, config)

server = app.listen config.port

module.exports =
  app: (callback)->
    mongoose.connection.db.dropDatabase()
    callback app
  shutdown : ->
    mongoose.connection.db.dropDatabase()
    server.close()
