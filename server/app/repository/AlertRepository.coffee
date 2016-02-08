mongoose = require 'mongoose'
AlertModel = mongoose.model 'alert'

module.exports =

  getAll : (callback)->
    AlertModel
    .find()
    .sort({date : -1})
    .exec (err, data)->
      callback(err, data)


  createAlert : (form, callback)->
    alert = new AlertModel
      date: new Date()
      sender: form.sender
      criticity: form.criticity
      type: form.type
      geoPosition:
        latitude: form.latitude
        longitude: form.longitude

    alert.save (err, alertSaved)->
      callback(err,alertSaved)

  createSpeechAlert : (type, user)->
    alert = new AlertModel
      date: new Date()
      sender: user.firstName+" "+user.lastName
      criticity: type.criticity
      type: type.name
      geoPosition:
        latitude: 3.555
        longitude: 12.5643

    alert.save()

  onGoing : (idAlert, user, callback)->
    AlertModel
    .findById(idAlert)
    .exec (err, alert)->
      if(alert && user)
        alert.receiver.push user._id
        alert.save()
      else if (!alert)
        err = { msg : "Alert does not exist"}
      else if (!user)
        err = { msg : "User is not loggin"}
      callback err, alert
