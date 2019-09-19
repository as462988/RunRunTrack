//
//  BadgeCollectionViewCell.swift
//  RunRunTruck
//
//  Created by yueh on 2019/9/17.
//  Copyright © 2019 yueh. All rights reserved.
//

import UIKit

class BadgeCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var logoImage: UIImageView!
    
    @IBOutlet weak var truckName: UILabel!
    
    
    func setValue(logo: String, name: String) {
        
        logoImage.loadImage(logo, placeHolder: UIImage.asset(.Icon_logo))
        logoImage.contentMode = .scaleAspectFill
        logoImage.clipsToBounds = true
        logoImage.layer.cornerRadius = self.bounds.height / 4
        truckName.text = name
    }
    
    func changeLayout(alpha: CGFloat) {
        
        logoImage.alpha = alpha
        
        truckName.alpha = alpha
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        layer.shadowPath = UIBezierPath(roundedRect: self.bounds, cornerRadius: 20).cgPath
        layer.shadowOffset = CGSize(width: 2, height: 2)
        layer.shadowRadius = 2
        layer.shadowOpacity = 0.7
        layer.shadowColor = UIColor.black.cgColor
        layer.masksToBounds = false
        
    }
}
