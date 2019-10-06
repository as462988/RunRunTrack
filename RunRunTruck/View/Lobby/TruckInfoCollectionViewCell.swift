//
//  TurckInfoCollectionViewCell.swift
//  RunRunTruck
//
//  Created by yueh on 2019/8/28.
//  Copyright © 2019 yueh. All rights reserved.
//

import UIKit

struct GeoLocation {
    
    let lat: Double
    
    let long: Double
    
}

protocol TruckInfoCellDelegate: AnyObject {
    func truckInfoCell(truckInfoCell: TruckInfoCollectionViewCell, didNavigateTo location: GeoLocation)
    func truckInfoCell(truckInfoCell: TruckInfoCollectionViewCell, didEnterTruckInfo truckData: TruckData)
    func truckInfoCell(truckInfoCell: TruckInfoCollectionViewCell, didEnterTruckChatRoom truckData: TruckData)
}
class TruckInfoCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var logoImage: UIImageView!
    @IBOutlet weak var truckName: UILabel!
    @IBOutlet weak var truckLocation: UILabel!
    @IBOutlet weak var openTime: UILabel!
    @IBOutlet weak var clickChatRoomBtn: UIButton!
    @IBOutlet weak var clickNavigateBtn: UIButton!
    @IBOutlet weak var clickTruckInfoBtn: UIButton!
    
    let dateManager = TransformTimeManager()
    
    var latitude: Double = 0.0
    var longitude: Double = 0.0
    weak var delegate: TruckInfoCellDelegate?
    var truckData: TruckData?
    
    func configureWithTruckData(truckData: TruckData) {
        self.truckData = truckData
        clickChatRoomBtn.addTarget(self, action: #selector(onGotoChatRoom), for: .touchUpInside)
        clickTruckInfoBtn.addTarget(self, action: #selector(enterTruckInfo), for: .touchUpInside)
    }
    
    func setValue(name: String, openTime: Double, logoImage: String, truckLocationText: String) {
        
        self.truckName.text = name
        self.openTime.text = dateManager.dateToString(time: openTime)
        self.truckLocation.text = truckLocationText
        
        if logoImage != "" {
            
            self.logoImage.loadImage(logoImage)
            
        } else {
            
            self.logoImage.image = UIImage.asset(.Icon_logo)
        }
    
        setImage()
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
    
    @IBAction func clickGoogleMapBtn() {
        
      self.delegate?.truckInfoCell(truckInfoCell: self, didNavigateTo: GeoLocation(lat: latitude, long: longitude))
        
    }
    
    private func setImage() {
        
        self.logoImage.contentMode = .scaleAspectFill
        
        self.logoImage.layer.cornerRadius = self.logoImage.frame.width / 2
        
        self.logoImage.clipsToBounds = true
        
    }
    
    @objc private func onGotoChatRoom() {
        
        if let truckData = truckData {
             self.delegate?.truckInfoCell(truckInfoCell: self, didEnterTruckChatRoom: truckData)
        }
    }
    
    @objc private func enterTruckInfo() {
        
        if let truckData = truckData {
            self.delegate?.truckInfoCell(truckInfoCell: self, didEnterTruckInfo: truckData)
        }
    }
}
