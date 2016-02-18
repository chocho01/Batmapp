import UIKit
import Material

/*
* Classe pour les items du menu
*/
public struct Item {
    var text: String
    var imageName: String
    var selected: Bool
    var action: String
}

/*
* Controlleur du menu
*/
class SideViewController: UIViewController, UITableViewDataSource, UITableViewDelegate , UIGestureRecognizerDelegate {

    private let tableView: UITableView = UITableView()
    let appdelegate = UIApplication.sharedApplication().delegate as! AppDelegate
    let mainStoryboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
    var items: Array<Item> = Array<Item>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        prepareView()
        prepareItems()
        prepareProfileView()
        prepareTableView()
    }
    
    private func prepareView() {
        view.backgroundColor = MaterialColor.white
    }

    /*
    * Création des items du menu
    */
    private func prepareItems() {
        items.append(Item(text: "Mon compte", imageName: "ic_account_circle", selected: false, action: "account"))
        items.append(Item(text: "Les dernières alertes", imageName: "bell-ring", selected: false, action: "alertList"))
        items.append(Item(text: "Créer une alerte", imageName: "bell-plus", selected: false, action: "addAlert"))
        items.append(Item(text: "Les utilisateurs", imageName: "ic_supervisor_account", selected: false, action: "users"))
        items.append(Item(text: "Déconnexion", imageName: "ic_input", selected: false, action: "logout"))
    }

    /*
    * Afficher le profil de l'utilisateur connecté
    */
    private func prepareProfileView() {
        let user : User = UserSession.sharedInstance.user
        let backgroundView: MaterialView = MaterialView()
        backgroundView.backgroundColor = MaterialColor.teal.lighten1
        
        let profileView: MaterialView = MaterialView()
        if let url = NSURL(string: UserSession.sharedInstance.user.imgProfil) {
            if let data = NSData(contentsOfURL: url) {
                profileView.image = UIImage(data: data)
            }
        }
        profileView.shape = .Circle
        profileView.borderColor = MaterialColor.white
        profileView.borderWidth = .Border3
        
        let nameLabel: UILabel = UILabel()
        nameLabel.text = "\(user.firstName) \(user.lastName)"
        nameLabel.textColor = MaterialColor.white
        nameLabel.font = RobotoFont.mediumWithSize(18)
        
        let emailLabel: UILabel = UILabel()
        emailLabel.text = "\(user.email)"
        emailLabel.textColor = MaterialColor.white
        emailLabel.font = RobotoFont.mediumWithSize(14)
        
        view.addSubview(backgroundView)
        backgroundView.translatesAutoresizingMaskIntoConstraints = false
        MaterialLayout.alignFromTop(view, child: backgroundView)
        MaterialLayout.alignToParentHorizontally(view, child: backgroundView)
        MaterialLayout.height(view, child: backgroundView, height: 150)
        
        backgroundView.addSubview(profileView)
        profileView.translatesAutoresizingMaskIntoConstraints = false
        MaterialLayout.alignFromTopLeft(backgroundView, child: profileView, top: 20, left: 20)
        MaterialLayout.size(backgroundView, child: profileView, width: 72, height: 72)
        
        backgroundView.addSubview(nameLabel)
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        MaterialLayout.alignFromBottom(backgroundView, child: nameLabel, bottom: 25)
        MaterialLayout.alignToParentHorizontally(backgroundView, child: nameLabel, left: 20, right: 20)
        
        backgroundView.addSubview(emailLabel)
        emailLabel.translatesAutoresizingMaskIntoConstraints = false
        MaterialLayout.alignFromBottom(backgroundView, child: emailLabel, bottom: 10)
        MaterialLayout.alignToParentHorizontally(backgroundView, child: emailLabel, left: 20, right: 20)
    }

    /*
    * Prépare le style du menu
    */
    private func prepareTableView() {
        tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        tableView.dataSource = self
        tableView.delegate = self
        tableView.separatorStyle = .None
        
        view.addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        MaterialLayout.alignToParent(view, child: tableView, top: 170)
    }

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count;
    }

    /*
    * Mise en page d'un item du menu dans la listView
    */
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell: UITableViewCell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath) as UITableViewCell
        cell.backgroundColor = MaterialColor.clear
        
        let item: Item = items[indexPath.row]
        cell.selectionStyle = .None
        cell.textLabel!.text = item.text
        cell.textLabel!.font = RobotoFont.medium
        cell.imageView!.image = UIImage(named: item.imageName)?.imageWithRenderingMode(.AlwaysTemplate)
        cell.imageView!.tintColor = MaterialColor.teal.base
        if item.selected {
            cell.textLabel!.textColor = MaterialColor.teal.base
        }
        
        return cell
    }

    /*
    * Hauteur d'une ligne du tableau
    */
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 64
    }
    
    /*
    * Gérer une action en fonction de l'item séléctionné
    */
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let indexPath = tableView.indexPathForSelectedRow!
        switch items[indexPath.row].action {
        case "account" :
            goToAccount()
            break
        case "logout" :
            goToConnexion()
            break
        case "users" :
            goToUsersList()
            break
        case "alertList" :
            goToLastAlert()
            break
        case "addAlert" :
            goToAddAlert()
            break
        default : break
        }
    }

    /*
    * Affiche la page de profil
    */
    func goToAccount(){
        let accountController = mainStoryboard.instantiateViewControllerWithIdentifier("ProfileController") as! ProfileController
        let sideView = SideViewController()
        appdelegate.window!.rootViewController = SideNavigationViewController(mainViewController: accountController, leftViewController: sideView)
        sideView.items[0].selected = true
    }

    /*
    * Affiche la page de connexion
    */
    func goToConnexion(){
        let connexionController = mainStoryboard.instantiateViewControllerWithIdentifier("connexionView") as! ConnexionController
        self.presentViewController(connexionController, animated: true, completion: nil)
    }

    /*
    * Affiche la liste des utilisateurs
    */
    func goToUsersList(){
        let userListController = mainStoryboard.instantiateViewControllerWithIdentifier("UserListController") as! UserListController
        let sideView = SideViewController()
        appdelegate.window!.rootViewController = SideNavigationViewController(mainViewController: userListController, leftViewController: sideView)
        sideView.items[3].selected = true
    }

    /*
    * Affiche la liste des alertes
    */
    func goToLastAlert(){
        let alertListViewController = mainStoryboard.instantiateViewControllerWithIdentifier("AlertListViewController") as! AlertListViewController
        let sideView = SideViewController()
        appdelegate.window!.rootViewController = SideNavigationViewController(mainViewController: alertListViewController, leftViewController: sideView)
        sideView.items[1].selected = true
    }

    /*
    * Affiche la page de création d'alerte
    */
    func goToAddAlert(){
        let addAlertController = mainStoryboard.instantiateViewControllerWithIdentifier("AddAlertController") as! AddAlertController
        let sideView = SideViewController()
        appdelegate.window!.rootViewController = SideNavigationViewController(mainViewController: addAlertController, leftViewController: sideView)
        sideView.items[2].selected = true
    }
    
    
}

