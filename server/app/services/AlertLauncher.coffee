VerEx = require 'verbal-expressions'
AlertRepository  = require '../repository/AlertRepository.coffee'
TypeAlert  = require '../utils/TypeAlert.coffee'

module.exports = (commands, user, callback)->
  wantLaunchAlert = new VerEx().then("alerte").or("secours").or("alert").or("aide").or("help")
  violAlert = new VerEx().then("viol").or("viole").or("violer").or("violé")
  aperoAlert = new VerEx().then("apéro").or("apero").or("go to the bar").or("boire")
  incendieAlert = new VerEx().then("incendie").or("feu").or("brûle").or("pompier").or("brûler")
  cambriolageAlert = new VerEx().then("cambriolage").or("voleur").or("vol").or("cambrioler").or("voler").or("intrusion").or("braquage")
  malaiseAlert = new VerEx().then("crise cardiaque").or("évanoui").or("malaise").or("tomber dans les pommes").or("tomber pommes").or("médecin")
  agressionAlert = new VerEx().then("agression").or("kidnapping").or("braquage").or("carjacké").or("agresser")

  isCmdUnderstandForAlert = false

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
      else if cambriolageAlert.test(command)
        AlertRepository.createSpeechAlert(TypeAlert["cambriolage"], user)
        callback("Ok j'avertis tout le monde du cambriolage")
      else if malaiseAlert.test(command)
        AlertRepository.createSpeechAlert(TypeAlert["malaise"], user)
        callback("Ok j'avertis tout le monde du cambriolage")
      else if agressionAlert.test(command)
        AlertRepository.createSpeechAlert(TypeAlert["agression"], user)
        callback("Ok j'avertis tout le monde du cambriolage")
      else if wantLaunchAlert.test(command)
        isCmdUnderstandForAlert = true

  if(isCmdUnderstandForAlert)
    AlertRepository.createSpeechAlert(TypeAlert["unknow"], user)
    callback("Ok j'avertis tout le monde")
  else
    callback("Je n'ai pas compris votre demande")
