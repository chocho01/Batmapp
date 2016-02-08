mongoose = require 'mongoose'
geolib = require 'geolib'
AlertModel = mongoose.model 'alert'

module.exports =

  getAll : (user, callback)->
    AlertModel
    .find()
    .sort({date : -1})
    .exec (err, data)->
      if(user && user.lastPosition)
        data = data.map (alert)->
            alert = alert.toJSON()
            alert.distance = geolib.getDistance(alert.geoPosition, user.lastPosition)
            return alert
      callback(err, data)


  createAlert : (form, user, callback)->
    alert = new AlertModel
      date: new Date()
      sender:
        id: user._id
        name: form.sender
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
        if(alert.receiver.indexOf(user._id)== -1)
          alert.receiver.push user._id
          alert.save()
        else
          err = { msg : "Vous êtes déja en chemin"}
      else if (!alert)
        err = { msg : "L'alerte n'existe pas"}
      else if (!user)
        err = { msg : "Vous n'êtes pas connecté"}
      callback err, alert

  callPolice : (idAlert, user, callback)->
    AlertModel
    .findById(idAlert)
    .exec (err, alert)->
      if(alert && user)
        if(!alert.police)
          alert.police = true
          alert.save()
        else
          err = { msg : "La police a déjà été contacté"}
      else if (!alert)
        err = { msg : "L'alerte n'existe pas"}
      else if (!user)
        err = { msg : "Vous n'êtes pas connecté"}
      callback err, alert
