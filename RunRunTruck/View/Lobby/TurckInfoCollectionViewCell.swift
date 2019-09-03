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
    @IBOutlet weak var truckLocation: UILabel!
    @IBOutlet weak var openTime: UILabel!
    @IBOutlet weak var closeTime: UILabel!
    @IBOutlet weak var clickChatRoomBtn: UIButton!
    
    var latitude: Double = 0.0
    var longitude: Double = 0.0
    
    func setValue(name: String, openTime: String, closeTime: String, logoImage: String, truckLocationText: String) {
        
        self.truckName.text = name
        self.openTime.text = openTime
        self.closeTime.text = closeTime
        self.truckLocation.text = truckLocationText
        
        if logoImage != "" {
            self.logoImage.loadImage(logoImage)
        } else {
            self.logoImage.image = UIImage.asset(.Icon_logo)
        }
    
        setImage()
    }
    
     // swiftlint:disable line_length
    @IBAction func clickGoogleMapBtn() {
        if UIApplication.shared.canOpenURL(URL(string: "comgooglemaps://")!) {
            UIApplication.shared.open(URL(string: "comgooglemaps://?saddr=&daddr=\(latitude),\(longitude)&center=\(latitude),\(longitude)&directionsmode=driving&zoom=17")!)
        } else {
            print("Can't use comgooglemaps://")
        }
    }
    // swiftlint:eable line_length
    
    private func setImage() {
        
        self.logoImage.contentMode = .scaleAspectFill
        self.logoImage.layer.cornerRadius = self.logoImage.frame.width / 2
        self.logoImage.clipsToBounds = true
    }

}
