VerEx = require 'verbal-expressions'
AlertRepository  = require '../repository/AlertRepository.coffee'
TypeAlert  = require '../utils/TypeAlert.coffee'

module.exports = (commands, user, callback)->
  wantLaunchAlert = new VerEx().then("alerte").or("secours").or("alert").or("aide").or("help")
  violAlert = new VerEx().then("viol").or("viole").or("violer").or("violé")
  aperoAlert = new VerEx().then("apéro").or("apero").or("go to the bar").or("boire")
  incendieAlert = new VerEx().then("incendie").or("feu").or("brule").or("pompier")

  commands.forEach (command)->
    if !isCmdUnderstand
      command = command.toLowerCase()
      if violAlert.test(command)
        AlertRepository.createSpeechAlert(TypeAlert["viol"], user)
        callback("Ok j'avertis tout le monde du viol")
        isCmdUnderstand = true
      else if aperoAlert.test(command)
        AlertRepository.createSpeechAlert(TypeAlert["apero"], user)
        callback("Ok j'avertis tout le monde pour l'apéro")
        isCmdUnderstand = true
      else if incendieAlert.test(command)
        AlertRepository.createSpeechAlert(TypeAlert["incendie"], user)
        callback("Ok j'avertis tout le monde de l'incendie")
        isCmdUnderstand = true
      else if wantLaunchAlert.test(command)
        AlertRepository.createSpeechAlert(TypeAlert["unknow"], user)
        callback("Ok j'avertis tout le monde")
        isCmdUnderstand = true

  callback("Je n'ai pas compris votre demande")
