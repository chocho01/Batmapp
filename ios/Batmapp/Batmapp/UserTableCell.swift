//
//  AlertTableCell.swift
//  Batmapp
//
//  Created by Martin Choraine on 20/01/2016.
//  Copyright © 2016 Martin Choraine. All rights reserved.
//

import UIKit
import Material

/*
* Table cell custom pour les utilisateurs
*/
class UserTableCell: UITableViewCell {
    

    @IBOutlet weak var imageCardView: ImageCardView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}
