//
//  TrcukCollectionViewCell.swift
//  RunRunTruck
//
//  Created by yueh on 2019/9/19.
//  Copyright © 2019 yueh. All rights reserved.
//

import UIKit

class TrcukCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var truckImage: UIImageView!
    
    @IBOutlet weak var truckNameLabel: UILabel!
    
    func setValue(name: String, image: String) {
        
        truckImage.loadImage(image)
        
        truckNameLabel.text = name
    }
    
    func modifyLayout() {
        
    }
    
    override func layoutSubviews() {
        
        truckImage.layer.cornerRadius = 10
        truckImage.clipsToBounds = true
    }
    
}
