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
import Lottie

protocol BossUIViewDelegate: GMSMapViewDelegate, UITextViewDelegate, AnyObject {
    func clickChenckBtn()
    func clickCancelBtn()
    func clickLogoutBtn()
    func creatQrcode()
    func clickChangeImage()
    func clickFeedbackBtn()
    func clickPrivateBtn()
}

class BossUIView: UIView {

    @IBOutlet weak var infoView: UIView!
    @IBOutlet weak var logoImage: UIImageView!
    @IBOutlet weak var detailImage: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var storyTextView: UITextView! {
        didSet {
            storyTextView.delegate = self.delegate
        }
    }
    
    @IBOutlet weak var btnContainView: UIView!
    @IBOutlet weak var logoOutBtn: UIButton!
    @IBOutlet weak var creatQrcodeBtn: UIButton!
    @IBOutlet weak var feedbackBtn: UIButton!
    @IBOutlet weak var privateBtn: UIButton!
    
    @IBOutlet weak var openSwitch: UISwitch!
    @IBOutlet weak var backgroundView: UIView!
    @IBOutlet weak var tapAnimationView: AnimationView!

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
    @IBOutlet weak var loactionAnimationView: AnimationView!

    weak var delegate: BossUIViewDelegate?

    override func awakeFromNib() {
        super.awakeFromNib()
        setMapView()
        openView.isHidden = true
        
        logoOutBtn.addTarget(self, action: #selector(clickLogoutBtn), for: .touchUpInside)
        
        feedbackBtn.addTarget(self, action: #selector(clickFeedbackBtn), for: .touchUpInside)
        
        privateBtn.addTarget(self, action: #selector(clickPrivateBtn), for: .touchUpInside)
        
        
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(clickChangeImage))
        
        detailImage.addGestureRecognizer(tapGestureRecognizer)
        
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
        mapView.bringSubviewToFront(loactionAnimationView)
    }

    func setupValue(name: String, story: String, image: String, detailImage: String, open: Bool) {
        
        logoImage.loadImage(image, placeHolder: UIImage.asset(.Icon_logo))
        self.detailImage.loadImage(detailImage)
        nameLabel.text = name
        storyTextView.text = story
        openSwitch.isOn = open
        btnContainView.layer.borderWidth = 1
        btnContainView.layer.borderColor = UIColor.lightGray.cgColor
//        btnContainView.layer.borderColor = UIColor(r: 63, g: 58, b: 58).cgColor
    }
    
    func cleanValue() {
        nameLabel.text = ""
        storyTextView.text = ""
    }
    
    func setLayout() {
        
        logoImage.layer.cornerRadius = logoImage.frame.width / 2
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
            FirebaseManager.shared.deleteChatRoom(truckID: (FirebaseManager.shared.currentUser?.truckId)!)
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
    
    @objc func clickChangeImage() {
        
        self.delegate?.clickChangeImage()
    }
    
    @objc func clickFeedbackBtn() {
        
        self.delegate?.clickFeedbackBtn()
        
    }
    @objc func clickPrivateBtn() {
        
        self.delegate?.clickPrivateBtn()
    }
}
