import SwiftyJSON

/*
* Parse un json pour retourner un objet Alert
*/
class AlertParser {

    /*
    * Parse un json pour retourner une liste d'alertes
    */
    static func parseAlertsFromJSON(json: JSON) -> [Alert] {
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "YYYY-MM-dd'T'HH:mm:ss.SSS'Z'"
        var alertList: [Alert] = []
        if let jsonArray = json.array {
            for jsonObject in jsonArray {
                let type = jsonObject["type"].stringValue
                let criticity = jsonObject["criticity"].int
                let date = dateFormatter.dateFromString(jsonObject["date"].stringValue)
                let senderObject = jsonObject["sender"].dictionary
                let senderName = senderObject!["name"]!.stringValue
                let senderImg = senderObject!["profilPicture"]!.stringValue
                let receiver = jsonObject["receiver"].arrayObject as! [String]
                let id = jsonObject["_id"].stringValue
                let geoposition = jsonObject["geoPosition"].dictionary
                let latitude = geoposition!["latitude"]?.doubleValue
                let longitude = geoposition!["longitude"]?.doubleValue
                let distance = jsonObject["distance"].intValue
                let police = jsonObject["police"].boolValue
                let samu = jsonObject["samu"].boolValue
                let resolve = jsonObject["solved"].boolValue
                if(jsonObject != nil){
                    alertList.append(Alert(id: id, type: type, criticity: criticity!, date: date!, senderName: senderName,senderImg:senderImg, receiver: receiver, latitude: latitude!, longitude: longitude!, distance: distance, police: police, samu:samu, resolve: resolve))
                }
            }
        }
        return alertList
    }

    /*
    * Parse un json pour retourner une alerte
    */
    static func parseAlertFromJSON(json: JSON) -> Alert {
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "YYYY-MM-dd'T'HH:mm:ss.SSS'Z'"
        let type = json["type"].stringValue
        let criticity = json["criticity"].int
        let date = dateFormatter.dateFromString(json["date"].stringValue)
        let senderObject = json["sender"].dictionary
        let senderName = senderObject!["name"]!.stringValue
        let senderImg = senderObject!["profilPicture"]!.stringValue
        let receiver = json["receiver"].arrayObject as! [String]
        let id = json["_id"].stringValue
        let geoposition = json["geoPosition"].dictionary
        let latitude = geoposition!["latitude"]?.doubleValue
        let longitude = geoposition!["longitude"]?.doubleValue
        let distance = json["distance"].intValue
        let police = json["police"].boolValue
        let samu = json["samu"].boolValue
        let resolve = json["solved"].boolValue
        return Alert(id: id, type: type, criticity: criticity!, date: date!, senderName: senderName, senderImg:senderImg,receiver: receiver, latitude: latitude!, longitude: longitude!, distance: distance, police: police, samu:samu, resolve: resolve)
    }

}