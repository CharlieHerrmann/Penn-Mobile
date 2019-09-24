//
//  CustomCell.swift
//  PennMobile
//
//  Created by Charlie Herrmann on 9/20/19.
//  Copyright © 2019 Charlie Herrmann. All rights reserved.
//

import Foundation
import UIKit
class customCell: UITableViewCell{
    var message : String?
    var image : UIImage?
    
    var messageView
    
    override init(style:UITableViewCell.CellStyle, reuseIdentifier: String?){
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
