import UIKit
import Material

/*
* TableCell custom pour les alertes de l'utilisateur
*/
class UserAlertsTableCell: UITableViewCell {

    @IBOutlet weak var cardView: CardView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}
