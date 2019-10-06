//
//  AddBossTruckViewController.swift
//  RunRunTruck
//
//  Created by yueh on 2019/9/10.
//  Copyright © 2019 yueh. All rights reserved.
//

import UIKit
import Lottie

class AddBossTruckViewController: UIViewController {
    
    @IBOutlet weak var truckNameInput: UITextField!
    @IBOutlet weak var truckTextInput: UITextView!
    @IBOutlet weak var showLogoImage: UIImageView!
    @IBOutlet weak var clickSendBtn: UIButton!
    @IBOutlet weak var animationView: AnimationView!
    
    var bossId: String?
    
    var logoImageUrl: String?
    
    let openChoseCameraManager = OpenChoseCameraManager()
    
    var userCreateTruckFinished = false {
        didSet {
            updateSendBtnStatus()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        checkBossAddTruck()
        openChoseCameraManager.delegate = self
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(choseUpLoadImage))
        animationView.addGestureRecognizer(tapGesture)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        handGester()

    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        setLayout()
    }
    
    func setLayout() {
        
        clickSendBtn.layer.cornerRadius = 20
        clickSendBtn.layer.masksToBounds = true
        
        animationView.layer.cornerRadius = animationView.frame.width / 2
        animationView.layer.masksToBounds = true
        truckTextInput.layer.cornerRadius = 20
        clickSendBtn.layer.masksToBounds = true
        
        showLogoImage.layer.cornerRadius = showLogoImage.frame.width / 2
        showLogoImage.layer.masksToBounds = true
        showLogoImage.layer.borderWidth = 1
        showLogoImage.layer.borderColor = UIColor.gray.cgColor
        showLogoImage.contentMode = .scaleAspectFill
        showLogoImage.clipsToBounds = true
        
    }
    
    @objc func choseUpLoadImage() {
        
        openChoseCameraManager.showImagePickerAlert(self)
    }
    
    func handGester() {
        animationView.animation = Animation.named(Lottie.camera.rawValue)
        animationView.loopMode = .loop
        animationView.play()
    }
    
    func updateSendBtnStatus() {
        
        setBtnStatus(userCreateTruckFinished ? .enable: .disable, btn: clickSendBtn)
    }
    
    func checkBossAddTruck() {
        
        if !truckTextInput.text.isEmpty, logoImageUrl != nil, !truckNameInput.text!.isEmpty {
            
            userCreateTruckFinished = true
            
        } else {
    
            userCreateTruckFinished = false
        }
        
    }
    
    @IBAction func clickSendBtn(_ sender: Any) {
        
        guard let inputText = truckTextInput.text else { return}
        
        guard let url = self.logoImageUrl else {return}
        
        addTruckData(url: url, inputText: inputText)
    }
    
    func addTruckData(url: String, inputText: String) {
        
        FirebaseManager.shared.addTruck(
            name: truckNameInput.text!,
            img: url,
            story: inputText) { [weak self] (truckId) in
                
                guard let bossID = self?.bossId else { return }

                FirebaseManager.shared.updateData(type: User.boss.rawValue,
                                                  uid: bossID,
                                                  key: Truck.truckId.rawValue,
                                                  value: truckId)
                
                FirebaseManager.shared.updateData(type: User.boss.rawValue,
                                                  uid: bossID,
                                                  key: User.name.rawValue,
                                                  value: self?.truckNameInput.text ?? "")
                
                DispatchQueue.main.async {
                    
                    guard let rootVC = AppDelegate.shared.window?.rootViewController
                        as? TabBarViewController else { return }
                    
                    rootVC.tabBar.isHidden = false
                    
                    self?.showAlert()
                }
        }
    }
    
    func showAlert() {
        
        let thankAlertVC = UIAlertController(title: "註冊成功！！！", message: "立即登入開始享受餐車旅程吧！", preferredStyle: .alert)
        
        present(thankAlertVC, animated: true, completion: nil)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
            let vc = self.presentingViewController
            self.dismiss(animated: true) {
                self.dismiss(animated: false) {
                    vc?.dismiss(animated: false, completion: nil)
                }
            }
        }
    }
}

extension AddBossTruckViewController: OpenChoseCameraManagerDelegate {
    
    func getTruckName(data: Data) {
        
        FirebaseStorageManager.shared.upLoadUserLogo(
            type: Truck.logoImage.rawValue,
            data: data) { url in
                
                guard let imageUrl = url else {return}
                
                self.logoImageUrl = imageUrl
                
                self.checkBossAddTruck()
        }
        
    }
    
    func imagePickerController(_ picker: UIImagePickerController,
                               didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
        
        openChoseCameraManager.upLoadImage(
            image: showLogoImage,
            info: info) { [weak self] (data) in
                
                guard let data = data else {return}
                
                self?.getTruckName(data: data)
                
                self?.dismiss(animated: true, completion: nil)
        }
    }
}
