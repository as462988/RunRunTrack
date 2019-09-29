//
//  TrcukCollectionViewCell.swift
//  RunRunTruck
//
//  Created by yueh on 2019/9/19.
//  Copyright © 2019 yueh. All rights reserved.
//

import UIKit
import Lottie

class TrcukCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var truckImage: UIImageView!
    
    @IBOutlet weak var truckLogoImage: UIImageView!
    
    @IBOutlet weak var truckNameLabel: UILabel!
    
    @IBOutlet weak var animationView: AnimationView!
    
    func setValue(name: String, logoImage: String, image: String) {
        
        truckImage.loadImage(image, placeHolder: UIImage.asset(.Image_truckPic))
        
        truckLogoImage.loadImage(logoImage, placeHolder: UIImage.asset(.Icon_logo))
        
        truckNameLabel.text = name
    }

    override func layoutSubviews() {
        truckLogoImage.layer.cornerRadius = truckLogoImage.frame.width / 2
        truckLogoImage.clipsToBounds = true
        truckImage.layer.cornerRadius = 10
        truckImage.clipsToBounds = true
    }
    
}
