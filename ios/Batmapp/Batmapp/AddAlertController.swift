import UIKit
import DownPicker
import Material

/*
* Controlleur de la page de création d'alert
*/
class AddAlertController: UIViewController {

    @IBOutlet weak var typeField: TextField!
    @IBOutlet weak var criticitySlider: UISlider!
    @IBOutlet weak var createAlert: RaisedButton!
    @IBOutlet weak var resultMsg: MaterialLabel!

    var typePicker: DownPicker!
    var speechRecognizer: SpeechRecognizer!

    override func viewDidLoad() {
        super.viewDidLoad()
        prepareNavBar()
        resultMsg.font = RobotoFont.regularWithSize(14)
        resultMsg.textAlignment = .Center
        createAlert.backgroundColor = MaterialColor.teal.base
        self.speechRecognizer = SpeechRecognizer()
        self.typePicker = DownPicker(textField: self.typeField, withData: Alert.allTypes)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    /*
    * Affiche la bar de navigation
    */
    private func prepareNavBar() {
        let navigationBarView: NavigationBarView = NavigationBarView()
        navigationBarView.backgroundColor = MaterialColor.teal.base
        navigationBarView.statusBarStyle = .LightContent

        let titleLabel: UILabel = UILabel()
        titleLabel.text = "Créer une alerte"
        titleLabel.textAlignment = .Left
        titleLabel.textColor = MaterialColor.white
        titleLabel.font = RobotoFont.regularWithSize(20)
        navigationBarView.titleLabel = titleLabel
        navigationBarView.titleLabelInset.left = 64

        let imgMenu: UIImage? = UIImage(named: "ic_menu_white")
        let btnMenu: FlatButton = FlatButton()
        btnMenu.pulseColor = MaterialColor.white
        btnMenu.pulseFill = true
        btnMenu.pulseScale = false
        btnMenu.setImage(imgMenu, forState: .Normal)
        btnMenu.setImage(imgMenu, forState: .Highlighted)
        btnMenu.addTarget(self, action: "showMenu", forControlEvents: .TouchUpInside)

        let imgMicro: UIImage? = UIImage(named: "microphonee")
        let btnRecord: FlatButton = FlatButton()
        btnRecord.pulseColor = MaterialColor.white
        btnRecord.pulseFill = true
        btnRecord.pulseScale = false
        btnRecord.setImage(imgMicro, forState: .Normal)
        btnRecord.setImage(imgMicro, forState: .Highlighted)
        btnRecord.addTarget(self, action: "record", forControlEvents: UIControlEvents.TouchDown)

        navigationBarView.rightButtons = [btnRecord]
        navigationBarView.leftButtons = [btnMenu]

        view.addSubview(navigationBarView)
        navigationBarView.translatesAutoresizingMaskIntoConstraints = false
        MaterialLayout.alignFromTop(view, child: navigationBarView)
        MaterialLayout.alignToParentHorizontally(view, child: navigationBarView)
        MaterialLayout.height(view, child: navigationBarView, height: 70)
    }

    /*
    * Lorsqu'on clique sur le bouton créer on envoi les données au serveur
    */
    @IBAction func createAlert(sender: AnyObject) {
        let criticity: Int = Int(criticitySlider.value)
        let user: User = UserSession.sharedInstance.user
        let alert = ["criticity": criticity, "type": typeField.text!, "sender": user.firstName + " " + user.lastName, "latitude": user.lastPosition!.latitude, "longitude": user.lastPosition!.longitude]
        RestManager.createAlert(alert as! [String:AnyObject]) {
            error in
        }
    }

    /*
    * Affiche le menu
    */
    func showMenu() {
        sideNavigationViewController?.toggleLeftView()
    }

    /*
    * Lance la reconnaisance vocale
    */
    func record() {
        self.speechRecognizer.startRecording(resultMsg)
    }

    /*
    * Lorsqu'on cliquer sur le bouton record
    */
    @IBAction func startRecord(sender: AnyObject) {
        record()
    }

    /*
    * Lorsqu'on relache le button record on arrete la reconnaissance vocale
    */
    @IBAction func stopRecord(sender: AnyObject) {
        self.speechRecognizer.stopRecorging()
    }
}