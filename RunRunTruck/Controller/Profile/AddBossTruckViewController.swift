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
    
    @IBOutlet weak var truckTextInput: UITextView!
    @IBOutlet weak var showLogoImage: UIImageView!
    @IBOutlet weak var clickSendBtn: UIButton!
    @IBOutlet weak var animationView: AnimationView!
    
    var logoImageUrl: String?
    
    let openChoseCameraManager = OpenChoseCameraManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
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

    @IBAction func clickSendBtn(_ sender: Any) {
        
        guard let inputText = truckTextInput.text else { return}
        
        guard inputText.isEmpty == false else {
            print("請跟我們分享你的故事")
            return
        }
        
        let truckName = FirebaseManager.shared.currentUser?.name
        
        guard let name = truckName, let url = self.logoImageUrl else {return}

        FirebaseManager.shared.addTurck(name: name,
                                        img: url,
                                        story: inputText) { [weak self] (truckID) in
                                            
                                            FirebaseManager.shared.addTurckIDInBoss(truckId: truckID)
                                            
                                            DispatchQueue.main.async {
                                                guard let rootVC = AppDelegate.shared.window?.rootViewController
                                                    as? TabBarViewController else { return }
                                                rootVC.tabBar.isHidden = false
                                                let vc = self?.presentingViewController
                                                self?.dismiss(animated: false) {
                                                    vc?.dismiss(animated: false, completion: nil)
                                                }
                                            }
        }
    }
}

extension AddBossTruckViewController: OpenChoseCameraManagerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController,
                               didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
        
        openChoseCameraManager.upLoadImage(
            image: showLogoImage,
            info: info) { [weak self] (data) in
                
                guard let data = data else {return}
                
                FirebaseStorageManager.shared.upLoadUserLogo(
                    type: Truck.logoImage.rawValue,
                    imageName: FirebaseManager.shared.currentUser!.name,
                    data: data) { url in
                        
                        guard let imageUrl = url else {return}
                        
                        self?.logoImageUrl = imageUrl
                }
                
                self?.dismiss(animated: true, completion: nil)
        }
    }
}
