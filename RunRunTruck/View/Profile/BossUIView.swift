//
//  BossUIView.swift
//  RunRunTruck
//
//  Created by yueh on 2019/9/10.
//  Copyright © 2019 yueh. All rights reserved.
//

import UIKit
import GoogleMaps
import CoreLocation
import Contacts

protocol BossUIViewDelegate: GMSMapViewDelegate, UITextViewDelegate, AnyObject {
    func clickChenckBtn()
    func clickCancelBtn()
    func clickLogoutBtn()
    func creatQrcode()
}

class BossUIView: UIView {

    @IBOutlet weak var infoView: UIView!
    @IBOutlet weak var logoImage: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var storyTextView: UITextView! {
        didSet {
            storyTextView.delegate = self.delegate
        }
    }
    @IBOutlet weak var logoOutBtn: UIButton!
    @IBOutlet weak var creatQrcodeBtn: UIButton!
    @IBOutlet weak var openSwitch: UISwitch!
    @IBOutlet weak var backgroundView: UIView!
    //open View
    @IBOutlet weak var openView: UIView!
    @IBOutlet weak var mapView: GMSMapView! {
        didSet {
            
            mapView.delegate = self.delegate
            
        }
    }
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var cancelBtn: UIButton!
    @IBOutlet weak var openBtn: UIButton!
    @IBOutlet weak var pinImage: UIImageView!
    
    weak var delegate: BossUIViewDelegate?

    override func awakeFromNib() {
        super.awakeFromNib()
        setLayout()
        setMapView()
        openView.isHidden = true
        
        logoOutBtn.addTarget(self, action: #selector(clickLogoutBtn), for: .touchUpInside)
    
        openSwitch.addTarget(self, action: #selector(onChange), for: .valueChanged)
        
        cancelBtn.addTarget(self, action: #selector(clickCancelBtn), for: .touchUpInside)
        
        openBtn.addTarget(self, action: #selector(clickChenckBtn), for: .touchUpInside)
        
        creatQrcodeBtn.addTarget(self, action: #selector(creatQrcode), for: .touchUpInside)
        
        mapView.delegate = self.delegate
        storyTextView.delegate = self.delegate
    }
    
    func setMapView() {
        
        let camera = GMSCameraPosition.camera(withLatitude: 25.033128, longitude: 121.565806, zoom: 15)
        mapView.camera = camera
        mapView.settings.myLocationButton = true
        mapView.isMyLocationEnabled = true
        mapView.bringSubviewToFront(pinImage)
    }

    func setupValue(name: String, story: String, image: String, open: Bool) {

        logoImage.loadImage(image, placeHolder: UIImage.asset(.Icon_logo))
        nameLabel.text = name
        storyTextView.text = story
        openSwitch.isOn = open
    }
    
    func cleanValue() {
        nameLabel.text = ""
        storyTextView.text = ""
    }
    
    func setLayout() {
        
        logoImage.layer.cornerRadius = UIScreen.main.bounds.width / 3 / 2
        logoImage.clipsToBounds = true
        logoImage.contentMode = .scaleAspectFill
 
        logoOutBtn.layer.cornerRadius = 10
        logoOutBtn.clipsToBounds = true
        storyTextView?.layer.cornerRadius = 10
        storyTextView?.clipsToBounds = true
        openView.layer.cornerRadius = 10
        openView.clipsToBounds = true
        openBtn.layer.cornerRadius = 10
        openBtn.clipsToBounds = true
        cancelBtn.layer.cornerRadius = 10
        cancelBtn.clipsToBounds = true
    
    }

    @objc func clickChenckBtn() {
        openSwitch.isOn = true
        openView.isHidden = true
        backgroundView.isHidden = true
        self.delegate?.clickChenckBtn()

    }
    
    @objc func clickCancelBtn() {
        
        openView.isHidden = true
        backgroundView.isHidden = true
        openSwitch.isOn = false
        self.delegate?.clickCancelBtn()
    }
    
    @objc func onChange(sender: AnyObject) {
        
        guard let tempSwitch = sender as? UISwitch else {return}
        
        if tempSwitch.isOn {
            
            openView.isHidden = false
            backgroundView.isHidden = false
            backgroundView.alpha = 0.4
            backgroundView.backgroundColor = .black
   
        } else {
            
            FirebaseManager.shared.changeOpenStatus(status: openSwitch.isOn)
            openView.isHidden = true
            backgroundView.isHidden = true
            
        }
    }
    
    @objc func clickLogoutBtn() {
        
        self.delegate?.clickLogoutBtn()
        cleanValue()
    }
    
    @objc func creatQrcode() {
        
        self.delegate?.creatQrcode()

    }

}
