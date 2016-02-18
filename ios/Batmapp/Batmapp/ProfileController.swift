import UIKit
import Material

/*
* Controlleur pour faire afficher le profil de l'utilisateur
* Afficher ses alertes
* Modifier son profil
*/
class ProfileController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    @IBOutlet weak var topBackground: UIView!
    @IBOutlet weak var profileView: MaterialView!
    @IBOutlet weak var actionBar: CardView!
    @IBOutlet weak var labelName: UILabel!
    @IBOutlet weak var tableView: UITableView!
    
    var userAlerts: [Alert] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        prepareNavBar()
        prepareProfilPicture()
        prepareProfileCard()
        getAlertList()
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
        titleLabel.text = "Mon compte"
        titleLabel.textAlignment = .Center
        titleLabel.textColor = MaterialColor.white
        titleLabel.font = RobotoFont.regularWithSize(20)
        navigationBarView.titleLabel = titleLabel
        
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

    /*
    * Affiche la photo et les informations de l'utilisateur
    */
    private func prepareProfilPicture(){
        topBackground.backgroundColor = MaterialColor.teal.lighten4
        
        if let url = NSURL(string: UserSession.sharedInstance.user.imgProfil) {
            if let data = NSData(contentsOfURL: url) {
                profileView.image = UIImage(data: data)
            }
        }
        
        profileView.shape = .Circle
        profileView.borderColor = MaterialColor.white
        profileView.borderWidth = .Border3
        profileView.translatesAutoresizingMaskIntoConstraints = false
        MaterialLayout.size(topBackground, child: profileView, width: 150, height: 150)

        labelName.text = "\(UserSession.sharedInstance.user.firstName) \(UserSession.sharedInstance.user.lastName)"
        labelName.textColor = MaterialColor.teal.darken3
        labelName.font = RobotoFont.regularWithSize(20)
    }

    /*
    * Affiche une toolbar pour modifier sa photo de profil
    */
    private func prepareProfileCard(){
        actionBar.divider = false
        actionBar.pulseColor = nil
        actionBar.pulseScale = false
        actionBar.backgroundColor = MaterialColor.teal.lighten5
        
        let imgUpload: UIImage? = UIImage(named: "ic_file_upload")
        let btnUploadImg: FlatButton = FlatButton()
        btnUploadImg.pulseColor = MaterialColor.white
        btnUploadImg.pulseFill = true
        btnUploadImg.pulseScale = false
        btnUploadImg.setImage(imgUpload, forState: .Normal)
        btnUploadImg.setImage(imgUpload, forState: .Highlighted)
        btnUploadImg.addTarget(self, action: "chooseImage", forControlEvents: .TouchUpInside)
        
        actionBar.rightButtons = [btnUploadImg]
    }

    /*
    * Affiche le menu sur la gauche
    */
    func showMenu() {
        sideNavigationViewController?.toggleLeftView()
    }
    
    /*
    * Récupère toutes les alertes de l'utilisateur
    */
    func getAlertList() {
        RestManager.getUserAlert(UserSession.sharedInstance.user.id) {
            err, alerts in
            self.userAlerts = alerts!
            self.tableView.reloadData()
        }
    }

    /*
    * Marquer l'alerte comme résolu
    */
    func resolveAlert(sender:ResolveButton){
        RestManager.resolveAlert(sender.idAlert!){
            err, alert in
            if((err) == nil){
                self.getAlertList()
            }
        }
    }

    /*
    * Ouvrir le navigateur d'image du device
    */
    func chooseImage(){
        let myPickerController = UIImagePickerController()
        myPickerController.delegate = self;
        myPickerController.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
        self.presentViewController(myPickerController, animated: true, completion: nil)
    }

    /*
    * Quand l'utilisateur choisit une image, l'upload sur le serveur
    */
    func imagePickerController(picker: UIImagePickerController!, didFinishPickingImage image: UIImage!, editingInfo: NSDictionary!) {
        let selectedImage : UIImage = image
        profileView.image = selectedImage
        dismissViewControllerAnimated(true, completion: nil)
        RestManager.uploadImageProfil(selectedImage)
    }

}

/*
* Extension de la classe pour afficher la liste des alertes
*/
extension ProfileController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.userAlerts.count
    }

    /*
    * Mise en page d'une alerte dans la listView
    */
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("UsersAlertCell", forIndexPath: indexPath) as! UserAlertsTableCell
        
        let alert: Alert = self.userAlerts[indexPath.row]
    
        let titleLabel: UILabel = UILabel()
        titleLabel.text = "\(alert.type)"
        titleLabel.numberOfLines = 0
        titleLabel.font = RobotoFont.mediumWithSize(18)
        cell.cardView.titleLabel = titleLabel

        let detailLabel: UILabel = UILabel()
        detailLabel.text = "\(alert.receiver.count) personnes en chemin"
        detailLabel.numberOfLines = 0
        cell.cardView.detailLabel = detailLabel

        let img1: UIImage? = UIImage(named: "ic_done")
        let btn1: ResolveButton = ResolveButton()
        btn1.pulseColor = MaterialColor.teal.base
        btn1.pulseFill = true
        btn1.pulseScale = false
        btn1.setImage(img1, forState: .Normal)
        btn1.setImage(img1, forState: .Highlighted)
        btn1.idAlert = alert.id
        btn1.addTarget(self, action: "resolveAlert:", forControlEvents: .TouchUpInside)
        
        let img2: UIImage? = UIImage(named: "samu")
        let btnSamu: FlatButton = FlatButton()
        btnSamu.pulseFill = true
        btnSamu.pulseScale = false
        btnSamu.setImage(img2, forState: .Normal)
        btnSamu.setImage(img2, forState: .Highlighted)
        
        let img3: UIImage? = UIImage(named: "police")
        let btnPolice: FlatButton = FlatButton()
        btnPolice.pulseFill = true
        btnPolice.pulseScale = false
        btnPolice.setImage(img3, forState: .Normal)
        btnPolice.setImage(img3, forState: .Highlighted)
        
        let btnResolve : FlatButton = FlatButton()
        btnResolve.pulseFill = true
        btnResolve.pulseScale = false
        btnResolve.setImage(img1, forState: .Normal)
        btnResolve.setImage(img1, forState: .Highlighted)
        
        var leftBtns : [FlatButton] = []
        if(alert.police){
            leftBtns.append(btnPolice)
        }
        if(alert.samu){
            leftBtns.append(btnSamu)
        }
        if(alert.resolve){
            leftBtns.append(btnResolve)
        }
        
        var rightBtns : [FlatButton] = []
        if(!alert.resolve){
            rightBtns.append(btn1)
        }
        
        cell.cardView.rightButtons = rightBtns
        cell.cardView.leftButtons = leftBtns
        
        return cell
    }

}