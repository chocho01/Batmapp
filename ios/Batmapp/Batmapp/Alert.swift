import Foundation
import SwiftyJSON

/*
* Classe d'alerte
*/
class Alert {
    
    var id: String
    var type: String
    var criticity: Int
    var date: NSDate
    var sender: (name:String, imgProfil:String)
    var receiver: [String]
    var geoPosition: (latitude:Double, longitude:Double)
    var distance: Int?
    var samu: Bool
    var police:Bool
    var resolve: Bool
    
    static let allTypes = ["Agression sexuel", "Viol", "Cambriolage", "Incendie", "Malaise", "Apéro"]
    
    init(id: String, type: String, criticity: Int, date: NSDate, senderName: String,senderImg: String,  receiver: [String], latitude: Double, longitude: Double, distance: Int, police : Bool, samu: Bool, resolve: Bool) {
        self.id = id
        self.type = type
        self.criticity = criticity
        self.date = date
        self.sender.name = senderName
        self.sender.imgProfil = RestManager.baseURL+"/img/profil/"+senderImg
        self.receiver = receiver
        self.geoPosition.latitude = latitude
        self.geoPosition.longitude = longitude
        self.distance = distance
        self.police = police
        self.samu = samu
        self.resolve = resolve
    }
    
}