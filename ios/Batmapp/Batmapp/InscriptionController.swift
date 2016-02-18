import UIKit
import Material

/*
* Controlleur pour créer un utilisateur
*/
class InscriptionController: UIViewController {

    @IBOutlet weak var emailInput: TextField!
    @IBOutlet weak var lastNameInput: TextField!
    @IBOutlet weak var firstNameInput: TextField!
    @IBOutlet weak var passwordInput: TextField!
    @IBOutlet weak var messageTxt: UITextView!
    @IBOutlet weak var inscriptionBtn: RaisedButton!

    override func viewDidLoad() {
        super.viewDidLoad()
        prepareEmailField()
        prepareLastNameField()
        prepareFirstNameField()
        prepareNavBar()
        preparePasswordField()
        inscriptionBtn.backgroundColor = MaterialColor.teal.base
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    /*
    * Lorsqu'on clique sur le bouton "s'inscrire" on envoi les informations au serveur
    */
    @IBAction func onClickInscriptionBtn(sender: AnyObject) {
        let user = ["email": emailInput.text!, "lastName": lastNameInput.text!, "firstName": firstNameInput.text!, "password": passwordInput.text!]
        RestManager.signupUser(user) {
            error in
            if (error) {
                let alertController = UIAlertController(title: "Inscription", message: "Vous êtes maintenant inscrit", preferredStyle: UIAlertControllerStyle.Alert)
                alertController.addAction(UIAlertAction(title: "Se connecter", style: UIAlertActionStyle.Default, handler: self.redirectHome))
                self.presentViewController(alertController, animated: true, completion: nil)
            } else {
                self.messageTxt.text = "L'utilisateur et/ou le mot de passe sont incorrects"
            }
        }
    }

    /*
    * Redirige vers la page de connexion
    */
    func redirectHome(alert: UIAlertAction!) {
        let vc = self.storyboard!.instantiateViewControllerWithIdentifier("connexionView") as! ConnexionController
        self.presentViewController(vc, animated: true, completion: nil)
    }

    /*
    * Affiche la bar de navigation
    */
    private func prepareNavBar(){
        let navigationBarView: NavigationBarView = NavigationBarView()
        navigationBarView.backgroundColor = MaterialColor.teal.base
        navigationBarView.statusBarStyle = .LightContent
        let titleLabel: UILabel = UILabel()
        titleLabel.text = "Inscription"
        titleLabel.textAlignment = .Center
        titleLabel.textColor = MaterialColor.white
        titleLabel.font = RobotoFont.regularWithSize(20)
        navigationBarView.titleLabel = titleLabel
        navigationBarView.titleLabelInset.left = 64
        
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
    * Affiche l'input email
    */
    private func prepareEmailField() {
        emailInput.clearButtonMode = .WhileEditing
        emailInput.font = RobotoFont.regularWithSize(20)
        emailInput.textColor = MaterialColor.black
        
        emailInput.titleLabel = UILabel()
        emailInput.titleLabel!.font = RobotoFont.mediumWithSize(12)
        emailInput.titleLabelColor = MaterialColor.teal.base
        emailInput.titleLabelActiveColor = MaterialColor.teal.accent3
    }

    /*
    * Affiche l'input nom
    */
    private func prepareLastNameField() {
        lastNameInput.clearButtonMode = .WhileEditing
        lastNameInput.font = RobotoFont.regularWithSize(20)
        lastNameInput.textColor = MaterialColor.black
        
        lastNameInput.titleLabel = UILabel()
        lastNameInput.titleLabel!.font = RobotoFont.mediumWithSize(12)
        lastNameInput.titleLabelColor = MaterialColor.teal.base
        lastNameInput.titleLabelActiveColor = MaterialColor.teal.accent3
    }

    /*
    * Affiche l'input prénom
    */
    private func prepareFirstNameField() {
        firstNameInput.clearButtonMode = .WhileEditing
        firstNameInput.font = RobotoFont.regularWithSize(20)
        firstNameInput.textColor = MaterialColor.black
        
        firstNameInput.titleLabel = UILabel()
        firstNameInput.titleLabel!.font = RobotoFont.mediumWithSize(12)
        firstNameInput.titleLabelColor = MaterialColor.teal.base
        firstNameInput.titleLabelActiveColor = MaterialColor.teal.accent3
    }

    /*
    * Affiche l'input password
    */
    private func preparePasswordField() {
        passwordInput.clearButtonMode = .WhileEditing
        passwordInput.font = RobotoFont.regularWithSize(20)
        passwordInput.textColor = MaterialColor.black
        
        passwordInput.titleLabel = UILabel()
        passwordInput.titleLabel!.font = RobotoFont.mediumWithSize(12)
        passwordInput.titleLabelColor = MaterialColor.teal.base
        passwordInput.titleLabelActiveColor = MaterialColor.teal.accent3
    }

    /*
    * Redirige vers la page de connexion
    */
    func goBack() {
        dispatch_async(dispatch_get_main_queue(), {
            () -> Void in
            self.performSegueWithIdentifier("backFromInscription", sender: self)
        })
    }



}