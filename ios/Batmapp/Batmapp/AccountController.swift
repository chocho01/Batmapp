import UIKit
import Alamofire
import SwiftyJSON
import Material

class AccountController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        prepareNavBar()
        prepareProfileCard()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
    private func prepareNavBar(){
        let navigationBarView: NavigationBarView = NavigationBarView()
        navigationBarView.backgroundColor = MaterialColor.teal.base
        navigationBarView.statusBarStyle = .LightContent
        let titleLabel: UILabel = UILabel()
        titleLabel.text = "Mon compte"
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
    
    private func prepareProfileCard(){
        let cardView: CardView = CardView()
        
        // Title label.
        let titleLabel: UILabel = UILabel()
        titleLabel.text = "Welcome Back!"
        titleLabel.textColor = MaterialColor.blue.darken1
        titleLabel.font = RobotoFont.mediumWithSize(20)
        cardView.titleLabel = titleLabel
        
        // Detail label.
        let detailLabel: UILabel = UILabel()
        detailLabel.text = "It’s been a while, have you read any new books lately?"
        detailLabel.numberOfLines = 0
        cardView.detailLabel = detailLabel
        
        // Yes button.
        let btn1: FlatButton = FlatButton()
        btn1.pulseColor = MaterialColor.blue.lighten1
        btn1.pulseFill = true
        btn1.pulseScale = false
        btn1.setTitle("YES", forState: .Normal)
        btn1.setTitleColor(MaterialColor.blue.darken1, forState: .Normal)
        
        // No button.
        let btn2: FlatButton = FlatButton()
        btn2.pulseColor = MaterialColor.blue.lighten1
        btn2.pulseFill = true
        btn2.pulseScale = false
        btn2.setTitle("NO", forState: .Normal)
        btn2.setTitleColor(MaterialColor.blue.darken1, forState: .Normal)
        
        // Add buttons to left side.
        cardView.leftButtons = [btn1, btn2]
        
        // To support orientation changes, use MaterialLayout.
        view.addSubview(cardView)
        cardView.translatesAutoresizingMaskIntoConstraints = false
        MaterialLayout.alignFromTop(view, child: cardView, top: 100)
        MaterialLayout.alignToParentHorizontally(view, child: cardView, left: 20, right: 20)
        
    }
    
}

