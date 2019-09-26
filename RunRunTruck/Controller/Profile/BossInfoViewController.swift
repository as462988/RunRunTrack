//
//  BossInfoViewController.swift
//  RunRunTruck
//
//  Created by yueh on 2019/9/11.
//  Copyright © 2019 yueh. All rights reserved.
//

import UIKit
import GoogleMaps
import Lottie

class BossInfoViewController: UIViewController {

    @IBOutlet weak var bossView: BossUIView! {
        didSet {
            bossView.delegate = self
        }
    }
    
    var latitude: Double?
    var longitude: Double?
    let addressManager = AddressManager()
    let openChoseCamera = OpenChoseCameraManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        
//        self.navigationController?.isNavigationBarHidden = true
        
        openChoseCamera.delegate = self
        
        FirebaseManager.shared.getBossTruck { [weak self](data) in
            
            guard let data = data else {return}
            
            self?.bossView.setupValue(name: data.name,
                                story: data.story,
                                image: data.logoImage,
                                detailImage: data.detailImage ?? "",
                                open: data.open)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.isNavigationBarHidden = true
        playTapAnimation()
        
        if let tabbarVc = self.navigationController?.tabBarController {
                  tabbarVc.tabBar.isHidden = false
              }
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        bossView.setLayout()
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    func playTapAnimation() {

        bossView.tapAnimationView.animation = Animation.named(Lottie.handGesture.rawValue)
        bossView.tapAnimationView.loopMode = .repeat(2)
        bossView.tapAnimationView.play()
    }
    
    func playLocationAnimation() {
        
        bossView.loactionAnimationView.animation = Animation.named(Lottie.location.rawValue)
        bossView.loactionAnimationView.loopMode = .loop
        bossView.loactionAnimationView.play()
    }
    
    internal func mapView(_ mapView: GMSMapView, idleAt position: GMSCameraPosition) {
        
        playLocationAnimation()
        
        self.latitude = position.target.latitude
        self.longitude = position.target.longitude
        
        guard let lat = self.latitude, let lon = self.longitude else {
            return
        }

        self.addressManager.getLocationAddress(lat: lat, long: lon) { [weak self] (location, error) in
            
            guard let location = location else {return}
            
            self?.bossView.addressLabel.text = location.subAdministrativeArea
                + location.city + location.street
            
        }
    }
}

extension BossInfoViewController: BossUIViewDelegate {
    
    func clickFeedbackBtn() {
        guard let feedbackVC = UIStoryboard.profile.instantiateViewController(
            withIdentifier: "feedbackVC") as? FeedbackViewController else {  return  }
        
        navigationController?.pushViewController(feedbackVC, animated: true)
    }
    
    func clickPrivateBtn() {
         guard let privateVC = UIStoryboard.profile.instantiateViewController(
            withIdentifier: "privateVC") as? PrivateViewController else {  return  }
        
        navigationController?.pushViewController(privateVC, animated: true)
    }

    func clickChenckBtn() {
        
        guard let lat = self.latitude, let lon = self.longitude else {return}
        
        FirebaseManager.shared.changeOpenStatus(status: bossView.openSwitch.isOn, lat: lat, lon: lon)
    }
    
    func clickCancelBtn() {
        FirebaseManager.shared.changeOpenStatus(status: bossView.openSwitch.isOn)
    }
    
    func clickLogoutBtn() {
        
        FirebaseManager.shared.signOut()
        
        let appDelegate = UIApplication.shared.delegate as? AppDelegate
        
        let root = appDelegate?.window?.rootViewController as? TabBarViewController
        
        root?.selectedIndex = 0
        
    }
    
    func creatQrcode() {
        
        guard let qrcodeVc = UIStoryboard.profile.instantiateViewController(
            withIdentifier: "qrcodeVc") as? CreatQrcodeViewController else { return }
        
        qrcodeVc.modalPresentationStyle = .overCurrentContext
        
        present(qrcodeVc, animated: false, completion: nil)
        
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        FirebaseManager.shared.updataStoryText(text: bossView.storyTextView.text)
    }
    
    func clickChangeImage() {
        openChoseCamera.showImagePickerAlert(self)
    }
}

extension BossInfoViewController: OpenChoseCameraManagerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController,
                               didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
        
        if let image = FirebaseManager.shared.currentUser?.logoImage {
            
            FirebaseStorageManager.shared.deleteImageFile(
                type: Truck.detailImage.rawValue,
                imageName: image)
        }
        
        openChoseCamera.upLoadImage(
            image: bossView.detailImage,
            info: info) { (data) in
                guard let data = data else {return}
                
                FirebaseStorageManager.shared.upLoadUserLogo(
                    type: Truck.detailImage.rawValue,
                    data: data, completion: { (url) in
                        
                        guard let imageUrl = url else {return}
                        
                        FirebaseManager.shared.updataDetailImageText(image: imageUrl)
                })
        }
        
            self.dismiss(animated: true, completion: nil)
    }
}
