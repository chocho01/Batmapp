import SwiftyJSON

/*
* Parse un json pour retourner un objet User
*/
class UserParser {

    /*
    * Parse un json pour retourner un utilisateur
    */
    static func parseUserFromJSON(json: JSON) -> User {
        let id = json["_id"].stringValue
        let firstName = json["firstName"].stringValue
        let lastName = json["lastName"].stringValue
        let email = json["email"].stringValue
        let img = json["profilPicture"].stringValue
        return User(id: id, email: email,firstName: firstName, lastName: lastName, imgProfil: img)
    }

    /*
    * Parse un json pour retourner une liste d'utilisateurs
    */
    static func parseUsersFromJSON(jsonResult: JSON) -> [User] {
        var userList: [User] = []
        if let jsonArray = jsonResult.array {
            for json in jsonArray {
                let id = json["_id"].stringValue
                let firstName = json["firstName"].stringValue
                let lastName = json["lastName"].stringValue
                let email = json["email"].stringValue
                let img = json["profilPicture"].stringValue
                if(json != nil){
                    userList.append(User(id: id, email: email,firstName: firstName, lastName: lastName, imgProfil: img))
                }
            }
        }
        return userList
    }
}