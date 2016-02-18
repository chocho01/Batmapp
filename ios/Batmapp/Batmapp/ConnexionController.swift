import UIKit
import Alamofire
import SwiftyJSON
import Material

/*
* Controlleur de la page de connexion
*/
class ConnexionController: UIViewController {

    @IBOutlet weak var PasswordInput: TextField!
    @IBOutlet weak var EmailInput: TextField!
    @IBOutlet weak var connexionBtn: RaisedButton!
    @IBOutlet weak var inscriptionBtn: RaisedButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        connexionBtn.backgroundColor = MaterialColor.teal.base
        inscriptionBtn.backgroundColor = MaterialColor.teal.base
        prepareNavBar()
        prepareEmailField()
        preparePasswordField()
    }

    /*
    * Affiche la bar de navigation
    */
    private func prepareNavBar(){
        let navigationBarView: NavigationBarView = NavigationBarView()
        navigationBarView.backgroundColor = MaterialColor.teal.base
        navigationBarView.statusBarStyle = .LightContent
        
        let titleLabel: UILabel = UILabel()
        titleLabel.text = "Connexion"
        titleLabel.textAlignment = .Center
        titleLabel.textColor = MaterialColor.white
        titleLabel.font = RobotoFont.regularWithSize(20)
        navigationBarView.titleLabel = titleLabel
        view.addSubview(navigationBarView)
        navigationBarView.translatesAutoresizingMaskIntoConstraints = false
        MaterialLayout.alignFromTop(view, child: navigationBarView)
        MaterialLayout.alignToParentHorizontally(view, child: navigationBarView)
        MaterialLayout.height(view, child: navigationBarView, height: 70)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    /*
    * Affiche le champs email
    */
    private func prepareEmailField() {
        EmailInput.clearButtonMode = .WhileEditing
        EmailInput.font = RobotoFont.regularWithSize(20)
        EmailInput.textColor = MaterialColor.black
        
        EmailInput.titleLabel = UILabel()
        EmailInput.titleLabel!.font = RobotoFont.mediumWithSize(12)
        EmailInput.titleLabelColor = MaterialColor.teal.base
        EmailInput.titleLabelActiveColor = MaterialColor.teal.accent3
        
        EmailInput.detailLabel = UILabel()
        EmailInput.detailLabel!.font = RobotoFont.mediumWithSize(8)
        EmailInput.detailLabel!.textColor = MaterialColor.red.base
        EmailInput.detailLabel?.text = "Login incorrect"
        EmailInput.detailLabelActiveColor = MaterialColor.red.base
    }

    /*
    * Affiche le champs password
    */
    private func preparePasswordField() {
        PasswordInput.clearButtonMode = .WhileEditing
        PasswordInput.font = RobotoFont.regularWithSize(20)
        PasswordInput.textColor = MaterialColor.black
        
        PasswordInput.titleLabel = UILabel()
        PasswordInput.titleLabel!.font = RobotoFont.mediumWithSize(12)
        PasswordInput.titleLabelColor = MaterialColor.teal.base
        PasswordInput.titleLabelActiveColor = MaterialColor.teal.accent3
        
        PasswordInput.detailLabel = UILabel()
        PasswordInput.detailLabel!.font = RobotoFont.mediumWithSize(8)
        PasswordInput.detailLabel!.textColor = MaterialColor.red.base
        PasswordInput.detailLabel?.text = "Password incorrect"
        PasswordInput.detailLabelActiveColor = MaterialColor.red.base
    }

    /*
    * Lorsqu'on clique sur le bouton connexion, on envoi les informations au serveur
    * Puis on redirige vers la liste des alertes si la connexion est ok
    */
    @IBAction func onConnexionBtnClick(sender:AnyObject) {
        if(!(PasswordInput.text ?? "").isEmpty && !(EmailInput.text ?? "").isEmpty){
            let parameters: [String:AnyObject] = ["user": EmailInput.text!, "password": PasswordInput.text!]
            RestManager.loginUser(parameters) { error, user in
            if(error){
                self.EmailInput.detailLabelHidden = false
                self.PasswordInput.detailLabelHidden = false
            } else {
                UserSession.sharedInstance.user = user
                UserSession.sharedInstance.startLocate()
                let appdelegate = UIApplication.sharedApplication().delegate as! AppDelegate
                let mainStoryboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
                let alertListViewController = mainStoryboard.instantiateViewControllerWithIdentifier("AlertListViewController") as! AlertListViewController
                appdelegate.window!.rootViewController = SideNavigationViewController(mainViewController: alertListViewController, leftViewController: SideViewController())
                }
            }
        }
    }

}

