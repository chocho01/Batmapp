import UIKit
import Material

/*
* Controlleur de la page de la liste des alertes non résolues
*/
class AlertListViewController: UIViewController, UITableViewDelegate,UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    var alertsList = []
    var alertSelected: Alert!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        prepareNavBar()
    }

    override func viewWillAppear(animated: Bool){
        super.viewWillAppear(animated)
        self.getAlertList()
        tableView.rowHeight = 100.0
        prepareNavBar()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
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
        
        let imgMap: UIImage? = UIImage(named: "ic_map_white")
        let btnMapView: FlatButton = FlatButton()
        btnMapView.pulseColor = MaterialColor.white
        btnMapView.pulseFill = true
        btnMapView.pulseScale = false
        btnMapView.setImage(imgMap, forState: .Normal)
        btnMapView.setImage(imgMap, forState: .Highlighted)
        btnMapView.addTarget(self, action: "showMapAlert", forControlEvents: .TouchUpInside)
        
        navigationBarView.leftButtons = [btnMenu]
        navigationBarView.rightButtons = [btnMapView]
        
        view.addSubview(navigationBarView)
        navigationBarView.translatesAutoresizingMaskIntoConstraints = false
        MaterialLayout.alignFromTop(view, child: navigationBarView)
        MaterialLayout.alignToParentHorizontally(view, child: navigationBarView)
        MaterialLayout.height(view, child: navigationBarView, height: 70)
    }

    /*
    * Récupère la liste des alertes en cours
    */
    func getAlertList() {
        RestManager.getAlerts() {
            alerts in
            self.alertsList = alerts
            self.tableView.reloadData()
        }
    }

    /*
    * Affiche la page des alertes sur une carte
    */
    func showMapAlert() {
        let appdelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let mainStoryboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let alertMapController = mainStoryboard.instantiateViewControllerWithIdentifier("AlertMap") as! AlertMapController
        let sideView = SideViewController()
        appdelegate.window!.rootViewController = SideNavigationViewController(mainViewController: alertMapController, leftViewController: sideView)
    }

    /*
    * Affiche le menu
    */
    func showMenu() {
        sideNavigationViewController?.toggleLeftView()
    }

    /*
    * Nombre de section de la tableView
    */
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    /*
    * Nombre de ligne de la tableView
    */
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.alertsList.count
    }

    /*
    * Mise en page d'une alerte dans la tableView
    */
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("AlertCell", forIndexPath: indexPath) as! AlertTableCell
        let alert: Alert = self.alertsList[indexPath.row] as! Alert
        cell.typeLabel?.text = alert.type
        cell.senderLabel?.text = "\(alert.sender.name) appelle au secours"
        cell.receiverLabel?.text = "\(alert.receiver.count) personnes en chemin"
        if let distance = alert.distance {
            let distanceKm : Double = Double(distance) / 1000
            if(distanceKm < 10){
                cell.distanceLabel?.text = "\(distanceKm.roundToPlaces(2)) Km"
            } else {
                cell.distanceLabel?.text = "\(Int(distanceKm)) Km"
            }
        }
        
        if let url = NSURL(string: alert.sender.imgProfil) {
            if let data = NSData(contentsOfURL: url) {
                cell.profilView.image = UIImage(data: data)
                cell.profilView.shape = .Circle
                cell.profilView.borderColor = MaterialColor.white
                cell.profilView.borderWidth = .Border3
                MaterialLayout.size(cell, child: cell.profilView, width: 55, height: 55)
            }
        }

        return cell
    }

    /*
    * Lorsqu'on séléctionne une alerte dans la tableView
    */
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let indexPath = tableView.indexPathForSelectedRow!
        alertSelected = alertsList[indexPath.row] as! Alert
        performSegueWithIdentifier("showAlertSegue", sender: self)
    }

    /*
    * Affiche le détail de l'alert séléctionné
    */
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if (segue.identifier == "showAlertSegue") {
            let viewController = segue.destinationViewController as! AlertController
            viewController.alertSelected = alertSelected
        }
    }

}

/*
* Extension de la classe double pour arrondir à x décimale
*/
extension Double {
    func roundToPlaces(places:Int) -> Double {
        let divisor = pow(10.0, Double(places))
        return round(self * divisor) / divisor
    }
}
