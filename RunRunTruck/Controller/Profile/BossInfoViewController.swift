//
//  BossInfoViewController.swift
//  RunRunTruck
//
//  Created by yueh on 2019/9/11.
//  Copyright © 2019 yueh. All rights reserved.
//

import UIKit
import GoogleMaps

class BossInfoViewController: UIViewController, BossUIViewDelegate {

    @IBOutlet weak var bossView: BossUIView! {
        didSet {
            bossView.delegate = self
        }
    }
    
    var latitude: Double?
    var longitude: Double?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.isNavigationBarHidden = true
        
        FirebaseManager.shared.getBossTruck { [weak self](data) in
            
            guard let data = data else {return}
            
            self?.bossView.setupValue(name: data.name,
                                story: data.story,
                                image: data.logoImage,
                                open: data.open)
        }

    }
    
    internal func mapView(_ mapView: GMSMapView, idleAt position: GMSCameraPosition) {
        
        self.latitude = position.target.latitude
        self.longitude = position.target.longitude
        
        guard let lat = self.latitude, let lon = self.longitude else {
            return
        }

        bossView.getLocation(lat: lat, long: lon) { [weak self] (location, error) in
            
            guard let location = location else {return}
            
            self?.bossView.addressLabel.text = location.subAdministrativeArea
                + location.city + location.street
            
        }
        
    }
    
    func clickChenckBtn() {
        
        guard let lat = self.latitude, let lon = self.longitude else {return}
        
        FirebaseManager.shared.changeOpenStatus(status: bossView.openSwitch.isOn, lat: lat, lon: lon)
    }
    
    func clickCancelBtn() {
        FirebaseManager.shared.closeOpenStatus(status: bossView.openSwitch.isOn)
    }
    
    func clickLogoutBtn() {
        
        FirebaseManager.shared.signOut()
        
        let appDelegate = UIApplication.shared.delegate as? AppDelegate
        
        let root = appDelegate?.window?.rootViewController as? TabBarViewController
        
        root?.selectedIndex = 0
        
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        FirebaseManager.shared.updataStoryText(text: bossView.storyTextView.text)
    }
}
