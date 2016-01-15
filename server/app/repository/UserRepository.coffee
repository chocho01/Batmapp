mongoose = require 'mongoose'
UserModel = mongoose.model 'User'

module.exports =

  getAll : (callback)->
    UserModel
      .find()
      .exec (err, data)->
        callback(err, data)
