//
//  TurckInfoCollectionViewCell.swift
//  RunRunTruck
//
//  Created by yueh on 2019/8/28.
//  Copyright © 2019 yueh. All rights reserved.
//

import UIKit

class TurckInfoCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var logoImage: UIImageView!
    @IBOutlet weak var truckName: UILabel!
     @IBOutlet weak var openTime: UILabel!
     @IBOutlet weak var closeTime: UILabel!
    
    func setValue(name: String, openTime: String, closeTime: String, logoImage: String) {
        
        self.logoImage.loadImage(logoImage)
        self.truckName.text = name
        self.openTime.text = openTime
        self.closeTime.text = closeTime
    }
}
