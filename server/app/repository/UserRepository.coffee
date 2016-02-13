mongoose = require 'mongoose'
md5 = require 'md5'
UserModel = mongoose.model 'user'

module.exports =

  getAll : (callback)->
    UserModel
      .find()
      .exec (err, data)->
        callback(err, data)

  updatePosition : (position, user, callback)->
      UserModel
        .findById(user._id)
        .exec (err, user)->
          user.lastPosition = position
          user.save()
          callback(err, user)

  updateImage : (user, profilImg, callback)->
    UserModel
      .findById(user._id)
      .exec (err, user)->
        user.profilPicture = profilImg
        user.save()
        callback(err, user)

  updateImage : (form, user, callback)->
    UserModel
      .findById(user._id)
      .exec (err, user)->
        user.token = form.token
        user.save()
        callback(err, user)


  createUser : (form, callback)->
    user = new UserModel
      email: form.email
      password: md5(form.password)
      firstName: form.firstName
      lastName: form.lastName

    user.save (err, userSaved)->
      callback(err,userSaved)
