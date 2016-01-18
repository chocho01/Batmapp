mongoose = require 'mongoose'
md5 = require 'md5'
UserModel = mongoose.model 'user'

module.exports =

  getAll : (callback)->
    UserModel
      .find()
      .exec (err, data)->
        callback(err, data)


  createUser : (form, callback)->
    user = new UserModel
      email: form.email
      password: md5(form.password)
      firstName: form.firstName
      lastName: form.lastName

    user.save (err, userSaved)->
      callback(err,userSaved)
