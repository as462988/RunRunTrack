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
    
    var latitude: Double = 0.0
    var longitude: Double = 0.0
    
    func setValue(name: String, openTime: String, closeTime: String, logoImage: String) {
        
        self.logoImage.loadImage(logoImage)
        self.truckName.text = name
        self.openTime.text = openTime
        self.closeTime.text = closeTime
    }
    
    @IBAction func clickGoogleMapBtn() {
        if UIApplication.shared.canOpenURL(URL(string: "comgooglemaps://")!) {
            UIApplication.shared.open(URL(string:
                "comgooglemaps://?center=\(latitude),\(longitude)&zoom=14")!)
        } else {
            print("Can't use comgooglemaps://")
        }
    }
}
