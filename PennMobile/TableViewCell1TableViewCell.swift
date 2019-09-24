//
//  TableViewCell1TableViewCell.swift
//  PennMobile
//
//  Created by Charlie Herrmann on 9/20/19.
//  Copyright © 2019 Charlie Herrmann. All rights reserved.
//

import UIKit

class TableViewCell1TableViewCell: UITableViewCell {

    @IBOutlet var mainImageView: UIImageView!
    @IBOutlet var mainLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
