import UIKit
import Material

/*
* TableCell custom pour les alertes
*/
class AlertTableCell: UITableViewCell {
    
    @IBOutlet weak var typeLabel: MaterialLabel!
    @IBOutlet weak var receiverLabel: MaterialLabel!
    @IBOutlet weak var senderLabel: MaterialLabel!
    @IBOutlet weak var distanceLabel: MaterialLabel!
    @IBOutlet weak var profilView: MaterialView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        typeLabel.font = RobotoFont.boldWithSize(14)
        receiverLabel.font = RobotoFont.regularWithSize(14)
        senderLabel.font = RobotoFont.regularWithSize(14)
        distanceLabel.font = RobotoFont.regularWithSize(14)
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}
