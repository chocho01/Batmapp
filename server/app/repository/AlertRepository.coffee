mongoose = require 'mongoose'
geolib = require 'geolib'
AlertModel = mongoose.model 'alert'

module.exports =

  getAll : (user, callback)->
    AlertModel
    .find({ $or: ["solved" : {$exists : false}, {"solved":false}]})
    .sort({date : -1})
    .exec (err, data)->
      if(user && user.lastPosition)
        data = data.map (alert)->
            alert = alert.toJSON()
            alert.distance = geolib.getDistance(alert.geoPosition, user.lastPosition)
            return alert
      callback(err, data)

  getUserAlers : (userId, user, callback)->
    AlertModel
    .find({"sender.id" : userId})
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
        profilPicture : user.profilPicture
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
      sender:
        id: user._id
        name: user.firstName+" "+user.lastName
        profilPicture : user.profilPicture
      criticity: type.criticity
      type: type.name
      geoPosition:
        latitude: user.lastPosition.latitude
        longitude:  user.lastPosition.longitude

    alert.save()

  onGoing : (idAlert, user, callback)->
    AlertModel
    .findById(idAlert)
    .exec (err, alert)->
      if(alert && user)
        if(alert.receiver.indexOf(user._id)== -1)
          alert.receiver.push user._id
          alert.save()
          alert = alert.toJSON()
          alert.distance = geolib.getDistance(alert.geoPosition, user.lastPosition)
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
          alert = alert.toJSON()
          alert.distance = geolib.getDistance(alert.geoPosition, user.lastPosition)
        else
          err = { msg : "La police a déjà été contacté"}
      else if (!alert)
        err = { msg : "L'alerte n'existe pas"}
      else if (!user)
        err = { msg : "Vous n'êtes pas connecté"}
      callback err, alert

  callSamu : (idAlert, user, callback)->
    AlertModel
    .findById(idAlert)
    .exec (err, alert)->
      if(alert && user)
        if(!alert.samu)
          alert.samu = true
          alert.save()
          alert = alert.toJSON()
          alert.distance = geolib.getDistance(alert.geoPosition, user.lastPosition)
        else
          err = { msg : "Le samu a déjà été contacté"}
      else if (!alert)
        err = { msg : "L'alerte n'existe pas"}
      else if (!user)
        err = { msg : "Vous n'êtes pas connecté"}
      callback err, alert

  resolve : (idAlert, user, callback)->
    AlertModel
      .findById(idAlert)
      .exec (err, alert)->
        if(alert && user)
          if alert.sender.id == user._id
            alert.solved = true
            alert.save()
          else
            err = { msg : "Vous n'êtes pas proprietaire de l'alert"}
        else
          err = { msg : "L'alerte n'existe pas"}
        callback err, alert

  udpatePositionOfUserAlert : (form, user)->
    AlertModel
    .find({"sender.id" : user._id})
    .exec (err, alerts)->
      alerts.forEach (alert)->
        alert.geoPosition.latitude = form.latitude
        alert.geoPosition.longitude = form.longitude
        alert.save()

  udpateImageOfUserAlert : (image, user)->
    AlertModel
    .find({"sender.id" : user._id})
    .exec (err, alerts)->
      alerts.forEach (alert)->
        alert.sender.profilPicture = image
