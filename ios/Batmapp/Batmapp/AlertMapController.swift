import UIKit
import MapKit
import Material

/*
* Controlleur de la liste des alertes sur une map
*/
class AlertMapController: UIViewController, MKMapViewDelegate  {
    
    @IBOutlet weak var mapView: MKMapView!
    
    override func viewDidLoad() {
        prepareNavBar()
        getAlertList()
        setZoom()
    }

    /*
    * Récupère la liste des alertes en cours
    */
    func getAlertList() {
        RestManager.getAlerts() {
            alerts in
            for alert in alerts {
                self.createMarkerOnMap(alert)
            }
        }
    }

    /*
    * Affiche le marker de l'alerte sur la carte
    */
    func createMarkerOnMap(alert : Alert) {
        let alertLocation = CLLocationCoordinate2D(latitude: alert.geoPosition.latitude, longitude: alert.geoPosition.longitude)
        let anotation = MKPointAnnotation()
        anotation.coordinate = alertLocation
        anotation.title = alert.type
        anotation.subtitle = "\(alert.sender.name) appelle au secours"
        mapView.addAnnotation(anotation)
    }

    /*
    * Positionne la map centré sur la position de l'utilisateur
    */
    func setZoom(){
        if(UserSession.sharedInstance.user.lastPosition != nil){
            let theSpan: MKCoordinateSpan = MKCoordinateSpanMake(0.6, 0.6)
            let currentLocation = CLLocationCoordinate2D(latitude: UserSession.sharedInstance.user.lastPosition!.latitude, longitude: UserSession.sharedInstance.user.lastPosition!.longitude)
            let theRegion: MKCoordinateRegion = MKCoordinateRegionMake(currentLocation, theSpan)
            mapView.setRegion(theRegion, animated: true)
        }
    }

    /*
    * Affiche la bar de navigation
    */
    private func prepareNavBar(){
        let navigationBarView: NavigationBarView = NavigationBarView()
        navigationBarView.backgroundColor = MaterialColor.teal.lighten1
        navigationBarView.statusBarStyle = .LightContent
        
        let titleLabel: UILabel = UILabel()
        titleLabel.text = "Liste des alertes"
        titleLabel.textAlignment = .Left
        titleLabel.textColor = MaterialColor.white
        titleLabel.font = RobotoFont.regularWithSize(20)
        navigationBarView.titleLabel = titleLabel
        navigationBarView.titleLabelInset.left = 64
        
        let detailLabel: UILabel = UILabel()
        detailLabel.text = "Les dernières alertes"
        detailLabel.textAlignment = .Left
        detailLabel.textColor = MaterialColor.white
        detailLabel.font = RobotoFont.regularWithSize(12)
        navigationBarView.detailLabel = detailLabel
        navigationBarView.detailLabelInset.left = 64
        
        let imgMenu: UIImage? = UIImage(named: "ic_menu_white")
        let btnMenu: FlatButton = FlatButton()
        btnMenu.pulseColor = MaterialColor.white
        btnMenu.pulseFill = true
        btnMenu.pulseScale = false
        btnMenu.setImage(imgMenu, forState: .Normal)
        btnMenu.setImage(imgMenu, forState: .Highlighted)
        btnMenu.addTarget(self, action: "showMenu", forControlEvents: .TouchUpInside)
        
        let imgList: UIImage? = UIImage(named: "ic_list_white")
        let btnList: FlatButton = FlatButton()
        btnList.pulseColor = MaterialColor.white
        btnList.pulseFill = true
        btnList.pulseScale = false
        btnList.setImage(imgList, forState: .Normal)
        btnList.setImage(imgList, forState: .Highlighted)
        btnList.addTarget(self, action: "showListAlert", forControlEvents: .TouchUpInside)
        
        navigationBarView.leftButtons = [btnMenu]
        navigationBarView.rightButtons = [btnList]
        
        view.addSubview(navigationBarView)
        navigationBarView.translatesAutoresizingMaskIntoConstraints = false
        MaterialLayout.alignFromTop(view, child: navigationBarView)
        MaterialLayout.alignToParentHorizontally(view, child: navigationBarView)
        MaterialLayout.height(view, child: navigationBarView, height: 70)
    }

    /*
    * Affiche le menu
    */
    func showMenu() {
        sideNavigationViewController?.toggleLeftView()
    }

    /*
    * Affiche la page de liste des alertes
    */
    func showListAlert() {
        let appdelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let mainStoryboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let alertMapController = mainStoryboard.instantiateViewControllerWithIdentifier("AlertListViewController") as! AlertListViewController
        let sideView = SideViewController()
        appdelegate.window!.rootViewController = SideNavigationViewController(mainViewController: alertMapController, leftViewController: sideView)
    }
}
