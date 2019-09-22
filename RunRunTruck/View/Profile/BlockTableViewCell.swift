//
//  BlockTableViewCell.swift
//  RunRunTruck
//
//  Created by yueh on 2019/9/22.
//  Copyright © 2019 yueh. All rights reserved.
//

import UIKit

class BlockTableViewCell: UITableViewCell {
    
    @IBOutlet weak var cancelBlockBtn: UIButton!
    @IBOutlet weak var nameLabel: UILabel!
    
    func setValue(name: String) {
        
        nameLabel.text = name

    }
    
    func setLayout() {
        cancelBlockBtn.layer.cornerRadius = 10
        cancelBlockBtn.clipsToBounds = true
    }
}
