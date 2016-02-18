import UIKit
import MapKit
import Material

/*
* Controlleur de la page de détail d'une alerte
*/

class AlertController: UIViewController, UIActionSheetDelegate, MKMapViewDelegate {

    @IBOutlet weak var typeLabel: UILabel!
    @IBOutlet weak var senderLabel: UILabel!
    @IBOutlet weak var receiverLabel: UILabel!
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var actionsBtn: FabButton!
    @IBOutlet weak var samuBtn: FlatButton!
    @IBOutlet weak var distanceLabel: UILabel!
    @IBOutlet weak var policeBtn: FlatButton!

    var alertSelected: Alert!
    var alertLocation: CLLocationCoordinate2D!
    var user = UserSession.sharedInstance.user

    override func viewDidLoad() {
        super.viewDidLoad()
        showAlertDetail()
        createMarkerOnMap()
        getDirections()
        prepareNavBar()
        prepareActionBtn()
        prepareSamuAndPoliceIcon()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    /*
    * Affiche les informations de l'alerte
    */
    private func showAlertDetail() {
        typeLabel?.text = alertSelected.type
        senderLabel?.text = "\(alertSelected.sender.name) appelle au secours"
        receiverLabel?.text = "\(alertSelected.receiver.count) personnes en chemin"
        if let distance = alertSelected.distance {
            let distanceKm: Double = Double(distance) / 1000
            if (distanceKm < 10) {
                distanceLabel?.text = "\(distanceKm.roundToPlaces(2)) Km"
            } else {
                distanceLabel?.text = "\(Int(distanceKm)) Km"
            }
        }
    }

    /*
    * Affiche la bar de navigation
    */
    private func prepareNavBar() {
        let navigationBarView: NavigationBarView = NavigationBarView()
        navigationBarView.backgroundColor = MaterialColor.teal.lighten1
        navigationBarView.statusBarStyle = .LightContent

        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "dd/MM/YY à HH:mm"

        let titleLabel: UILabel = UILabel()
        titleLabel.text = "Alerte"
        titleLabel.textAlignment = .Left
        titleLabel.textColor = MaterialColor.white
        titleLabel.font = RobotoFont.regularWithSize(20)
        navigationBarView.titleLabel = titleLabel
        navigationBarView.titleLabelInset.left = 64

        let detailLabel: UILabel = UILabel()
        detailLabel.text = "Le \(dateFormatter.stringFromDate(alertSelected.date))"
        detailLabel.textAlignment = .Left
        detailLabel.textColor = MaterialColor.white
        detailLabel.font = RobotoFont.regularWithSize(12)
        navigationBarView.detailLabel = detailLabel
        navigationBarView.detailLabelInset.left = 64

        let imgBack: UIImage? = UIImage(named: "arrow-left-bold")
        let btnBack: FlatButton = FlatButton()
        btnBack.pulseColor = MaterialColor.white
        btnBack.pulseFill = true
        btnBack.pulseScale = false
        btnBack.setImage(imgBack, forState: .Normal)
        btnBack.setImage(imgBack, forState: .Highlighted)
        btnBack.addTarget(self, action: "goBack", forControlEvents: UIControlEvents.TouchDown)

        navigationBarView.leftButtons = [btnBack]

        view.addSubview(navigationBarView)
        navigationBarView.translatesAutoresizingMaskIntoConstraints = false
        MaterialLayout.alignFromTop(view, child: navigationBarView)
        MaterialLayout.alignToParentHorizontally(view, child: navigationBarView)
        MaterialLayout.height(view, child: navigationBarView, height: 70)
    }

    /*
    * Affiche l'icone police/samu si appelé
    */
    func prepareSamuAndPoliceIcon() {
        print(alertSelected.samu)
        policeBtn.pulseColor = MaterialColor.white
        policeBtn.pulseFill = true
        policeBtn.pulseScale = false

        samuBtn.pulseColor = MaterialColor.white
        samuBtn.pulseFill = true
        samuBtn.pulseScale = false

        if (!alertSelected.samu) {
            samuBtn.hidden = true
        } else {
            samuBtn.hidden = false
        }

        if (!alertSelected.police) {
            policeBtn.hidden = true
        } else {
            policeBtn.hidden = false
        }
    }

    /*
    * Affiche le bouton d'action
    */
    func prepareActionBtn() {
        actionsBtn.backgroundColor = MaterialColor.teal.base
        let img1: UIImage? = UIImage(named: "bell")
        actionsBtn.setImage(img1, forState: .Normal)
        actionsBtn.setImage(img1, forState: .Highlighted)
    }

    /*
    * Retour à la liste des alertes
    */
    func goBack() {
        let appdelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let mainStoryboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let alertListViewController = mainStoryboard.instantiateViewControllerWithIdentifier("AlertListViewController") as! AlertListViewController
        appdelegate.window!.rootViewController = SideNavigationViewController(mainViewController: alertListViewController, leftViewController: SideViewController())
    }

    /*
    * Liste des actions
    */
    @IBAction func downloadSheet(sender: AnyObject) {
        let actionSheet = UIActionSheet(
        title: "Choisir une option",
                delegate: self,
                cancelButtonTitle: "Annuler",
                destructiveButtonTitle: nil,
                otherButtonTitles: "J'arrive", "Appeler la police", "Appeler le samu", "Fausse alerte")
        actionSheet.showInView(self.view)
    }

    /*
    * Lorsqu'on séléctionne une action, on effectu l'action correspondante
    */
    func actionSheet(actionSheet: UIActionSheet, clickedButtonAtIndex buttonIndex: Int) {
        switch (buttonIndex) {
        case 1:
            RestManager.userGoingOnAlert(alertSelected.id) {
                err, alert in
                if ((err) != nil) {
                    self.showAlertModal(err!)
                } else {
                    self.alertSelected = alert
                    self.showAlertDetail()
                }
            }

        case 2:
            RestManager.callPoliceOnAlert(alertSelected.id) {
                err, alert in
                if ((err) != nil) {
                    self.showAlertModal(err!)
                } else {
                    self.alertSelected = alert
                    self.showAlertDetail()
                    self.prepareSamuAndPoliceIcon()
                }
            }

        case 3:
            RestManager.callSamuOnAlert(alertSelected.id) {
                err, alert in
                if ((err) != nil) {
                    self.showAlertModal(err!)
                } else {
                    self.alertSelected = alert
                    self.showAlertDetail()
                    self.prepareSamuAndPoliceIcon()
                }
            }
        default: break
        }
    }

    /*
    * Affiche une popup en fonction du résultat de l'action
    */
    func showAlertModal(msg: String) {
        let alertController = UIAlertController(title: "Erreur", message:
        msg, preferredStyle: UIAlertControllerStyle.Alert)
        alertController.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default, handler: nil))

        self.presentViewController(alertController, animated: true, completion: nil)
    }

    /*
    * Affiche le marker de l'alert sur la map
    */
    func createMarkerOnMap() {
        let theSpan: MKCoordinateSpan = MKCoordinateSpanMake(0.01, 0.01)
        alertLocation = CLLocationCoordinate2D(latitude: alertSelected.geoPosition.latitude, longitude: alertSelected.geoPosition.longitude)
        let theRegion: MKCoordinateRegion = MKCoordinateRegionMake(alertLocation, theSpan)

        mapView.setRegion(theRegion, animated: true)
        let anotation = MKPointAnnotation()
        anotation.coordinate = alertLocation
        anotation.title = alertSelected.type
        anotation.subtitle = "\(alertSelected.sender.name) appelle au secours"
        mapView.addAnnotation(anotation)

        let longPress = UILongPressGestureRecognizer(target: self, action: "action:")
        longPress.minimumPressDuration = 1.0
    }

    /*
    * Récupère le chemin entre l'alerte et l'utilisateur
    */
    func getDirections() {
        if ((user.lastPosition) != nil) {
            let currentLocation: CLLocationCoordinate2D = CLLocationCoordinate2D(latitude: user.lastPosition!.latitude, longitude: user.lastPosition!.longitude)

            let placeDest = MKPlacemark(coordinate: alertLocation, addressDictionary: nil)
            let placeSource = MKPlacemark(coordinate: currentLocation, addressDictionary: nil)

            let request = MKDirectionsRequest()
            request.source = MKMapItem.init(placemark: placeSource)
            request.destination = MKMapItem.init(placemark: placeDest)
            request.transportType = MKDirectionsTransportType.Automobile
            request.requestsAlternateRoutes = false

            let directions = MKDirections(request: request)

            directions.calculateDirectionsWithCompletionHandler({
                (response: MKDirectionsResponse?, error: NSError?) -> () in
                if error == nil {
                    self.showRoute(response!)
                }
            })
        }
    }

    /*
    * Dessine le chemin sur la map
    */
    func showRoute(response: MKDirectionsResponse) {
        for route in response.routes {
            mapView.addOverlay(route.polyline, level: MKOverlayLevel.AboveRoads)
        }
    }

    /*
    * Modifier le style du chemin
    */
    func mapView(mapView: MKMapView, rendererForOverlay overlay: MKOverlay) -> MKOverlayRenderer {
        let renderer = MKPolylineRenderer(overlay: overlay)
        renderer.strokeColor = MaterialColor.teal.lighten1
        renderer.lineWidth = 5.0
        return renderer
    }
}

