VerEx = require 'verbal-expressions'



module.exports = (command, callback)->
    command = command[0]
    wantLaunchAlert = new VerEx().then("alerte").or("secours").or("alert").or("aide").or("help")
    if wantLaunchAlert.test(command)
      callback("Ok j'avertis tout le monde")
    else
      callback("Je n'ai pas compris votre demande")
