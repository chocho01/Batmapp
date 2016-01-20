import UIKit
import Alamofire
import SwiftyJSON

class ViewController: UIViewController {

    @IBOutlet weak var PasswordInput: UITextField!
    @IBOutlet weak var EmailInput: UITextField!
    @IBOutlet weak var messageText: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func onConnexionBtnClick(sender:AnyObject) {
        if(!(PasswordInput.text ?? "").isEmpty && !(EmailInput.text ?? "").isEmpty){
            let parameters: [String:AnyObject] = ["user": EmailInput.text!, "password": PasswordInput.text!]
            Alamofire.request(.POST, "http://batmapp.martin-choraine.fr/api/login", parameters: parameters).responseJSON { response in
                let statusCode = (response.response?.statusCode)!
                if(statusCode==200)     {
                    if let jsonObject = response.result.value {
                        let user = User.parseUserFromJSON(JSON(jsonObject))
                        print(user)
                        let vc = self.storyboard!.instantiateViewControllerWithIdentifier("alertListView") as! AlertListViewController
                        self.presentViewController(vc, animated: true, completion: nil)
                    }
                } else {
                    self.messageText.text = "L'utilisateur et/ou le mot de passe sont incorrects"
                }
            }
        } else {
            self.messageText.text = "Tous les champs sont obligatoires"
        }
    }

}

