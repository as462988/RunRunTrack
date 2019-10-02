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
    
    struct NotificationContent {
        static let title = "開店啦！"
        static let body = "現在就去找他們吧"
    }
    
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
            withIdentifier: String(describing: FeedbackViewController.self)) as? FeedbackViewController
            else {  return  }
        
        navigationController?.pushViewController(feedbackVC, animated: true)
    }
    
    func clickPrivateBtn() {
         guard let privateVC = UIStoryboard.profile.instantiateViewController(
            withIdentifier: String(describing: PrivateViewController.self)) as? PrivateViewController else {  return  }
        navigationController?.pushViewController(privateVC, animated: true)
    }

    func clickOpenStatusBtn() {
        
        guard let lat = self.latitude, let lon = self.longitude else {return}
        guard let currentTruck = FirebaseManager.shared.bossTruck else {return}
        FirebaseManager.shared.changeOpenStatus(status: bossView.openSwitch.isOn, lat: lat, lon: lon)
        // 只推送訊息給訂閱此餐車的用戶
        FirebaseNotificationManager.share.sendPushNotification(
            toTopic: currentTruck.id,
            title: currentTruck.name + NotificationContent.title,
            body: NotificationContent.body)
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
            withIdentifier: String(describing: CreatQrcodeViewController.self)) as? CreatQrcodeViewController
            else { return }
        
        qrcodeVc.modalPresentationStyle = .overCurrentContext
        
        present(qrcodeVc, animated: false, completion: nil)
        
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        
        guard let truckId =  FirebaseManager.shared.bossTruck?.id else {return}
        
        FirebaseManager.shared.updataData(type: Truck.truck.rawValue,
                                              uid: truckId,
                                              key: Truck.story.rawValue,
                                              value: bossView.storyTextView.text)

    }
    
    func clickChangeImage() {
        openChoseCamera.showImagePickerAlert(self)
    }
}

extension BossInfoViewController: OpenChoseCameraManagerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController,
                               didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
        
        openChoseCamera.upLoadImage(
            image: bossView.detailImage,
            info: info) { (data) in
                guard let data = data else {return}
                
                FirebaseStorageManager.shared.upLoadUserLogo(
                    type: Truck.detailImage.rawValue,
                    data: data, completion: { (url) in
                        
                        guard let imageUrl = url else {return}
                        
                        if let truckId = FirebaseManager.shared.bossTruck?.id {
                        
                        FirebaseManager.shared.updataData(type: Truck.truck.rawValue,
                                                          uid: truckId,
                                                          key: Truck.detailImage.rawValue,
                                                          value: imageUrl)
                        }
                })
        }
            self.dismiss(animated: true, completion: nil)
    }
}
