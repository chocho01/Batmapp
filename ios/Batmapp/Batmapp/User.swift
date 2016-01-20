import Foundation
import SwiftyJSON

class User {
    var firstName: String
    var lastName: String
    var email: String
    
    init(email : String, firstName : String, lastName: String){
        self.email = email
        self.firstName = firstName
        self.lastName = lastName
    }
    
    static func parseUserFromJSON(json: JSON) -> User {
        let firstName = json["firstName"].stringValue
        let lastName = json["lastName"].stringValue
        let email = json["email"].stringValue
        return User(email: email,firstName: firstName, lastName: lastName)
    }
}



