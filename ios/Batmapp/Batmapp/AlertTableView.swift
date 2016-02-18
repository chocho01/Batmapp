import UIKit
import Alamofire
import SwiftyJSON

class AlertTableView: UITableView {
    
    var alertsList = []
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.alertsList.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("AlertCell", forIndexPath: indexPath) as! AlertTableCell
        
        let alert: Alert = self.alertsList[indexPath.row] as! Alert
        cell.typeLabel?.text = alert.type
        cell.senderLabel?.text = "\(alert.sender) appelle au secours"
        cell.receiverLabel?.text = "\(alert.receiver) personnes en chemin"
        return cell
    }
    
}
