import UIKit
import Alamofire
import SwiftyJSON

class InscriptionController : UIViewController {
    
    @IBOutlet weak var emailInput: UITextField!
    @IBOutlet weak var lastNameInput: UITextField!
    @IBOutlet weak var firstNameInput: UITextField!
    @IBOutlet weak var passwordInput: UITextField!
    @IBOutlet weak var messageTxt: UITextView!
    
    override func viewWillAppear(animated: Bool) {
        navigationItem.title = "Inscription"
    }
    
    override func viewDidLoad() {
        print("loaded")
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func onClickInscriptionBtn(sender: AnyObject) {
        let parameters = ["email": emailInput.text!, "lastName" : lastNameInput.text!, "firstName": firstNameInput.text!, "password": passwordInput.text!]
        Alamofire.request(.POST, "http://batmapp.martin-choraine.fr/api/users", parameters: parameters).responseJSON { response in
            let statusCode = (response.response?.statusCode)!
            if(statusCode==200)     {
                let alertController = UIAlertController(title: "Inscription", message: "Vous êtes maintenant inscrit", preferredStyle: UIAlertControllerStyle.Alert)
                alertController.addAction(UIAlertAction(title: "Se connecter", style: UIAlertActionStyle.Default,handler: self.redirectHome))
                self.presentViewController(alertController, animated: true, completion: nil)
                
            } else {
                self.messageTxt.text = "L'utilisateur et/ou le mot de passe sont incorrects"
            }
        }
    }
    
    func redirectHome(alert: UIAlertAction!) {
        let vc = self.storyboard!.instantiateViewControllerWithIdentifier("connexionView") as! ViewController
        self.presentViewController(vc, animated: true, completion: nil)
    }
}