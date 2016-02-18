import Alamofire
import SwiftyJSON
import UIKit

/*
* Classe pour encapsuler tous les appels à l'API côté serveur
*/
class RestManager {
    
    static let baseURL: String = "http://batmapp.martin-choraine.fr"

    /*
    * API pour créer un utilisateur avec une email, un mot de passe, un nom et un prénom
    */
    static func signupUser(parameters: [String:AnyObject], completionHandler: (Bool) -> ()) {
        Alamofire.request(.POST, RestManager.baseURL + "/api/users", parameters: parameters).responseJSON {
            response in
            let statusCode = (response.response?.statusCode)!
            if (statusCode == 200) {
                completionHandler(true)
            } else {
                completionHandler(false)
            }
        }
    }

    /*
    * API pour authentifier un utilisateur avec une email et un mot de passe
    */
    static func loginUser(parameters : [String:AnyObject], completionHandler: (Bool, User?) -> ()) {
        Alamofire.request(.POST, baseURL + "/api/login", parameters: parameters).responseJSON {
            response in
            let statusCode = (response.response?.statusCode)!
            if (statusCode == 200) {
                if let jsonObject = response.result.value {
                    completionHandler(false, UserParser.parseUserFromJSON(JSON(jsonObject)))
                }
            } else {
                completionHandler(true, nil)
            }
        }
    }

    /*
    * API pour retourner la liste de tous les utilisateurs
    */
    static func getUsers(completionHandler: (Bool, [User]?) -> ()) {
        Alamofire.request(.GET, baseURL + "/api/users").responseJSON {
            response in
            let statusCode = (response.response?.statusCode)!
            if (statusCode == 200) {
                if let jsonObject = response.result.value {
                    completionHandler(false, UserParser.parseUsersFromJSON(JSON(jsonObject)))
                }
            } else {
                completionHandler(true, nil)
            }
        }
    }
    
    /*
    * API pour mettre à jour la position de l'utilisateur connecté et de ses alerts
    */
    static func updatePositionUser(parameters: [String:AnyObject]){
        Alamofire.request(.POST, baseURL + "/api/users/update-position", parameters: parameters).responseJSON {
            response in
        }
    }

    /*
    * API pour retourner toutes les alertes non résolues
    */
    static func getAlerts(completionHandler: ([Alert]) -> ()) {
        let URL = NSURL(string: baseURL+"/api/alerts/")!
        let URLRequest = NSMutableURLRequest(URL: URL)
        URLRequest.cachePolicy = .ReloadIgnoringCacheData
        Alamofire.request(URLRequest).responseJSON { response in
            if let jsonObject = response.result.value {
                completionHandler(AlertParser.parseAlertsFromJSON(JSON(jsonObject)))
            }
        }
    }

    /*
    * API pour créer une alerte
    */
    static func createAlert(parameters : [String:AnyObject], completionHandler: (Bool) -> ()) {
        Alamofire.request(.POST, baseURL + "/api/alerts", parameters: parameters).responseJSON {
            response in
            let statusCode = (response.response?.statusCode)!
            if (statusCode == 200) {
                completionHandler(false)
            } else {
                completionHandler(true)
            }
        }
    }

    /*
    * API pour créer une alerte à partir d'une commande vocale
    */
    static func createAlertFromSpeech(speech : [String], completionHandler: (String?) -> ()){
        let parameters = ["msg" : speech]
        Alamofire.request(.POST, baseURL + "/api/alerts/command", parameters: parameters).responseJSON {
            response in
            let statusCode = (response.response?.statusCode)!
            if (statusCode == 200) {
                if let jsonObject = response.result.value {
                    completionHandler(jsonObject["result"] as? String)
                } else {
                    completionHandler(nil)
                }
            } else {
                completionHandler(nil)
            }
        }
    }

    /*
    * API pour spécifier que l'utilisateur courand est en chemin sur l'alerte
    */
    static func userGoingOnAlert(idAlert: String, completionHandler: (String?, Alert?) -> ()){
        let parameters = ["action" : "onGoing"]
        Alamofire.request(.POST, baseURL + "/api/alerts/ongoing/"+idAlert, parameters: parameters).responseJSON {
            response in
            let statusCode = (response.response?.statusCode)!
            if (statusCode == 200) {
                if let jsonObject = response.result.value {
                    completionHandler(nil, AlertParser.parseAlertFromJSON(JSON(jsonObject)))
                }
            } else {
                if let jsonObject = response.result.value {
                    completionHandler(jsonObject["msg"] as? String, nil)
                }
            }
        }
    }

    /*
    * API pour appeler la police sur l'alerte
    */
    static func callPoliceOnAlert(idAlert: String, completionHandler: (String?, Alert?) -> ()){
        let parameters = ["action" : "callPolice"]
        Alamofire.request(.POST, baseURL + "/api/alerts/call-police/"+idAlert, parameters: parameters).responseJSON {
            response in
            let statusCode = (response.response?.statusCode)!
            if (statusCode == 200) {
                if let jsonObject = response.result.value {
                    completionHandler(nil, AlertParser.parseAlertFromJSON(JSON(jsonObject)))
                }
            } else {
                if let jsonObject = response.result.value {
                    completionHandler(jsonObject["msg"] as? String, nil)
                }
            }
        }
    }

    /*
    * API pour appeler le samu sur l'alerte
    */
    static func callSamuOnAlert(idAlert: String, completionHandler: (String?, Alert?) -> ()){
        let parameters = ["action" : "callSamu"]
        Alamofire.request(.POST, baseURL + "/api/alerts/call-samu/"+idAlert, parameters: parameters).responseJSON {
            response in
            let statusCode = (response.response?.statusCode)!
            if (statusCode == 200) {
                if let jsonObject = response.result.value {
                    completionHandler(nil, AlertParser.parseAlertFromJSON(JSON(jsonObject)))
                }
            } else {
                if let jsonObject = response.result.value {
                    completionHandler(jsonObject["msg"] as? String, nil)
                }
            }
        }
    }

    /*
    * API pour spécifier que l'alerte est résolu
    */
    static func resolveAlert(idAlert: String, completionHandler: (String?, Alert?) -> ()){
        let parameters = ["action" : "resolve"]
        Alamofire.request(.POST, baseURL + "/api/alerts/resolve/"+idAlert, parameters: parameters).responseJSON {
            response in
            let statusCode = (response.response?.statusCode)!
            if (statusCode == 200) {
                if let jsonObject = response.result.value {
                    completionHandler(nil, AlertParser.parseAlertFromJSON(JSON(jsonObject)))
                }
            } else {
                if let jsonObject = response.result.value {
                    completionHandler(jsonObject["msg"] as? String, nil)
                }
            }
        }
    }

    /*
    * API pour uploader une image et l'attacher à l'utilisateur connecté
    */
    static func uploadImageProfil(image : UIImage?){
        Alamofire.upload(.POST, baseURL+"/api/users/upload", multipartFormData: {
            multipartFormData in
                if let _image = image {
                    if let imageData = UIImageJPEGRepresentation(_image, 0.5) {
                        multipartFormData.appendBodyPart(data: imageData, name: "file", fileName: "file.png", mimeType: "image/png")
                    }
                }
            }, encodingCompletion: { encodingResult in
                switch encodingResult {
                case .Success(let upload, _, _):
                    upload.responseJSON { request in
                        let result = request
                        print(result.result)
                    }
                case .Failure(let encodingError):
                    print(encodingError)
                }
            }
        )
    }

    /*
    * API pour retourner toutes les alertes de l'utilisateur connecté
    */
    static func getUserAlert(idUser: String, completionHandler: (String?, [Alert]?) -> ()){
        print(idUser)
        Alamofire.request(.GET, baseURL + "/api/alerts/user/"+idUser).responseJSON {
            response in
            let statusCode = (response.response?.statusCode)!
            if (statusCode == 200) {
                if let jsonObject = response.result.value {
                    completionHandler(nil, AlertParser.parseAlertsFromJSON(JSON(jsonObject)))
                }
            } else {
                if let jsonObject = response.result.value {
                    completionHandler(jsonObject["msg"] as? String, nil)
                }
            }
        }
    }
    
}
