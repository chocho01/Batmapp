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

  createSpeechAlert : (type)->
    alert = new AlertModel
      date: new Date()
      sender: "Bot"
      criticity: type.criticity
      type: type.name
      geoPosition:
        latitude: 3.555
        longitude: 12.5643

    alert.save()
