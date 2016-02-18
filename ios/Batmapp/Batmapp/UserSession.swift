import Foundation
import CoreLocation

/*
* Singleton pour recupérer l'utilisateur connecté à tout moment
*/
class UserSession : NSObject, CLLocationManagerDelegate {
    
    let locationManager = CLLocationManager()
    var currentLocation: CLLocationCoordinate2D!
    var user: User!

    /*
    * Retourne l'unique instance de la classe
    */
    class var sharedInstance: UserSession {
        struct Static {
            static var instance: UserSession = UserSession()
        }
        return Static.instance
    }

    /*
    * Detecter le changement de position de l'utilisateur
    */
    func startLocate(){
        self.locationManager.requestAlwaysAuthorization()
        self.locationManager.requestWhenInUseAuthorization()
        if CLLocationManager.locationServicesEnabled() {
            self.locationManager.delegate = self
            self.locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            self.locationManager.startUpdatingLocation()
        }
    }

    /*
    * Quand la localisation de l'utilisateur a changé on envoi sa nouvelle position au serveur
    */
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        self.user.lastPosition = (latitude : manager.location!.coordinate.latitude, longitude : manager.location!.coordinate.longitude)
        RestManager.updatePositionUser(["latitude" :self.user.lastPosition!.latitude, "longitude" :self.user.lastPosition!.longitude])
    }
}