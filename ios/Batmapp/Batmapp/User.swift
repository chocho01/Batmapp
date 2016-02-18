import Foundation

/*
* Classe d'utilisateur
*/
class User {
    var id: String
    var firstName: String
    var lastName: String
    var email: String
    var lastPosition: (latitude:Double, longitude:Double)?
    var imgProfil: String
    var largeImgProfil : String
    
    init(id : String, email : String, firstName : String, lastName: String, imgProfil: String){
        self.id = id
        self.email = email
        self.firstName = firstName
        self.lastName = lastName
        self.imgProfil = RestManager.baseURL+"/img/profil/"+imgProfil
        self.largeImgProfil = RestManager.baseURL+"/img/profil/large-"+imgProfil
    }
    
}



