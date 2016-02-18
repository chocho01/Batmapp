import UIKit
import Material

/*
* Controlleur de la liste des utilisateurs
*/
class UserListController: UIViewController , UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var usersTable: UITableView!
    
    var usersList : [User]! = []
    var usersCard : [ImageCardView]! = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        prepareNavBar()
        getUsers()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    /*
    * Récupère la liste des utilisateur
    */
    private func getUsers(){
        RestManager.getUsers() {
            err, users in
            self.usersList = users
            self.usersTable.reloadData()
        }
    }

    /*
    * Récupère la bar de navigation
    */
    private func prepareNavBar() {
        let navigationBarView: NavigationBarView = NavigationBarView()
        navigationBarView.backgroundColor = MaterialColor.teal.lighten1
        navigationBarView.statusBarStyle = .LightContent
        
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "dd/MM/YY hh:mm"
        
        let titleLabel: UILabel = UILabel()
        titleLabel.text = "Les utilisateurs"
        titleLabel.textAlignment = .Left
        titleLabel.textColor = MaterialColor.white
        titleLabel.font = RobotoFont.regularWithSize(20)
        navigationBarView.titleLabel = titleLabel
        navigationBarView.titleLabelInset.left = 64
        
        let img1: UIImage? = UIImage(named: "ic_menu_white")
        let btn1: FlatButton = FlatButton()
        btn1.pulseColor = MaterialColor.white
        btn1.pulseFill = true
        btn1.pulseScale = false
        btn1.setImage(img1, forState: .Normal)
        btn1.setImage(img1, forState: .Highlighted)
        btn1.addTarget(self, action: "showMenu", forControlEvents: .TouchUpInside)
        
        navigationBarView.leftButtons = [btn1]
        
        view.addSubview(navigationBarView)
        navigationBarView.translatesAutoresizingMaskIntoConstraints = false
        MaterialLayout.alignFromTop(view, child: navigationBarView)
        MaterialLayout.alignToParentHorizontally(view, child: navigationBarView)
        MaterialLayout.height(view, child: navigationBarView, height: 70)
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.usersList.count
    }

    /*
    * Mise en page d'un user dans la listeView
    */
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("UserCell", forIndexPath: indexPath) as! UserTableCell
        let user: User = self.usersList[indexPath.row]
                
        if let url = NSURL(string: user.largeImgProfil) {
            if let data = NSData(contentsOfURL: url) {
                cell.imageCardView.image = UIImage(data: data)
            }
        }
        
        let titleLabel: UILabel = UILabel()
        titleLabel.text = "\(user.firstName) \(user.lastName)"
        titleLabel.textColor = MaterialColor.white
        titleLabel.font = RobotoFont.mediumWithSize(24)
        cell.imageCardView.titleLabel = titleLabel
        cell.imageCardView.titleLabelInset.top = 100
        
        let detailLabel: UILabel = UILabel()
        detailLabel.text = "\(user.email)"
        detailLabel.numberOfLines = 0
        cell.imageCardView.detailLabel = detailLabel
        
        let img1: UIImage? = UIImage(named: "ic_star")
        let btn1: FlatButton = FlatButton()
        btn1.pulseColor = MaterialColor.yellow.base
        btn1.pulseFill = true
        btn1.pulseScale = false
        btn1.setImage(img1, forState: .Normal)
        btn1.setImage(img1, forState: .Highlighted)

        cell.imageCardView.rightButtons = [btn1]

        return cell
    }

    /*
    * Affiche le menu
    */
    func showMenu() {
        sideNavigationViewController?.toggleLeftView()
    }
    
    
}