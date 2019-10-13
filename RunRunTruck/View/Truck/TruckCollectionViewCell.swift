//
//  TrcukCollectionViewCell.swift
//  RunRunTruck
//
//  Created by yueh on 2019/9/19.
//  Copyright © 2019 yueh. All rights reserved.
//

import UIKit
import Lottie

class TruckCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var truckImage: UIImageView!
    
    @IBOutlet weak var truckLogoImage: UIImageView!
    
    @IBOutlet weak var truckNameLabel: UILabel!
    
    @IBOutlet weak var truckOpenStatusImage: UIImageView!
    
    func setValue(name: String, logoImage: String, image: String, isOpen: Bool) {
        
        truckImage.loadImage(image, placeHolder: UIImage.asset(.Image_truckPic))
        
        truckLogoImage.loadImage(logoImage, placeHolder: UIImage.asset(.Icon_logo))
        
        truckNameLabel.text = name
        
        truckOpenStatusImage.image = UIImage.asset(isOpen ? .Icon_open: .Icon_close)
        
    }

    override func layoutSubviews() {
        truckLogoImage.layer.cornerRadius = truckLogoImage.frame.width / 2
        truckLogoImage.clipsToBounds = true
        truckImage.layer.cornerRadius = 10
        truckImage.clipsToBounds = true
    }
    
}
