//
//  TableViewCell2.swift
//  PennMobile
//
//  Created by Charlie Herrmann on 9/20/19.
//  Copyright © 2019 Charlie Herrmann. All rights reserved.
//

import UIKit
//custom table view cell
class TableViewCell2: UITableViewCell {
    @IBOutlet var mainImageView: UIImageView!
    //properties of table custom table view cell
    @IBOutlet var nameLabel: UILabel!
    @IBOutlet var openLabel: UILabel!
    @IBOutlet var hoursLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
