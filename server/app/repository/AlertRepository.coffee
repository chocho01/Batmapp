mongoose = require 'mongoose'
AlertModel = mongoose.model 'alert'

module.exports =

  getAll : (callback)->
    AlertModel
    .find()
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
