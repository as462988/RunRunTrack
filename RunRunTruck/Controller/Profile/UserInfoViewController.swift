//
//  UserInfoViewController.swift
//  RunRunTruck
//
//  Created by yueh on 2019/9/11.
//  Copyright © 2019 yueh. All rights reserved.
//

import UIKit
import Lottie

class UserInfoViewController: UIViewController {

    @IBOutlet weak var userView: UserUIView!
    
    let openChoseCameraManager = OpenChoseCameraManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        userView.delegate = self
        openChoseCameraManager.delegate = self
        
        self.navigationController?.isNavigationBarHidden = true
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
         handGester()
        
        FirebaseManager.shared.getCurrentUserData { (userData) in
            
            guard let data = userData else {return}
            
            if data.logoImage == nil {
            
            self.userView.setupValue(name: data.name)
                
            } else {
                self.userView.setupValue(name: data.name, image: data.logoImage)
            }
        }
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        userView.setLayout()
    }
    
    func handGester() {
        
        userView.animationView.animation = Animation.named(Lottie.camera.rawValue)
        userView.animationView.loopMode = .repeat(2)
        userView.animationView.play()
    }
}

extension UserInfoViewController: UserUIViewDelegate {
    
    func clickUpLoadBtn() {
        openChoseCameraManager.showImagePickerAlert(self)
    }
}

extension UserInfoViewController: OpenChoseCameraManagerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController,
                               didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
        
        if let image = FirebaseManager.shared.currentUser?.logoImage {
        
        FirebaseStorageManager.shared.deleteImageFile(
            type: User.logoImage.rawValue,
            imageName: image)
        }
        
        openChoseCameraManager.upLoadImage(
            image: userView.logoImage,
            info: info) { (data) in
                
                guard let data = data else {return}
                
                 FirebaseStorageManager.shared.upLoadUserLogo(
                    type: User.logoImage.rawValue,
                    imageName: FirebaseManager.shared.currentUser?.name ?? "",
                    data: data,
                    completion: { (url) in
                        
                        guard let imageUrl = url else {return}
                        
                        FirebaseManager.shared.updataUserImage(image: imageUrl)
                 })
                
        }
        dismiss(animated: true, completion: nil)
    }
}
