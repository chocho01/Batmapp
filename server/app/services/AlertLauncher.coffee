VerEx = require 'verbal-expressions'
AlertRepository  = require '../repository/AlertRepository.coffee'

module.exports = (commands, callback)->
  wantLaunchAlert = new VerEx().then("alerte").or("secours").or("alert").or("aide").or("help")
  violAlert = new VerEx().then("viol").or("viole").or("violer").or("violé")

  commands.forEach (command)->
    if wantLaunchAlert.test(command)
      if violAlert.test(command)
        AlertRepository.createSpeechAlert("Viol")
        callback("Ok j'avertis tout le monde du viol")
        break
      else
        AlertRepository.createSpeechAlert("Inconnu")
        callback("Ok j'avertis tout le monde")
        break

  callback("Je n'ai pas compris votre demande")
