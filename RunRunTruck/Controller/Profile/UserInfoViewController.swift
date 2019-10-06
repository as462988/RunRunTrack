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
    
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var userView: UserUIView!
    
    let openChoseCameraManager = OpenChoseCameraManager()
    
    var contentCollectionView: ProfileContentCollectionViewController = ProfileContentCollectionViewController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        userView.delegate = self
        
        openChoseCameraManager.delegate = self
        
        contentView.addSubview(contentCollectionView.view)
        
        contentCollectionView.view.fillSuperview()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        handGester()
        
        navigationController?.isNavigationBarHidden = true
        
        if let user = FirebaseManager.shared.currentUser {
            
            self.userView.setupValue(name: user.name, image: user.logoImage ?? nil)
            
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
    
    func clickSettingBtn() {
        let settingVC = SettingViewController()
        
        setNarVCBackBtn(vc: settingVC)
    }
    
    func clickUpLoadBtn() {
        openChoseCameraManager.showImagePickerAlert(self)
    }
    
    func clickEditNameBtn() {
        guard let editNameVc = UIStoryboard.profile.instantiateViewController(
            identifier: String(describing: EditNameViewController.self)) as? EditNameViewController else {return}
        setNarVCBackBtn(vc: editNameVc)
        if let user = FirebaseManager.shared.currentUser {
            editNameVc.name = user.name
        }
    }
    
    func setNarVCBackBtn(vc: UIViewController) {
        navigationController?.isNavigationBarHidden = false
        navigationItem.leftBarButtonItem = UIBarButtonItem(
            image: UIImage.asset(.Icon_back),
            style: .plain,
            target: self,
            action: nil)
        navigationController?.pushViewController(vc, animated: true)
    }
}

extension UserInfoViewController: OpenChoseCameraManagerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController,
                               didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
        
        openChoseCameraManager.upLoadImage(
            image: userView.logoImage,
            info: info) { (data) in
                
                guard let data = data else {return}
                
                FirebaseStorageManager.shared.upLoadUserLogo(
                    type: User.logoImage.rawValue,
                    data: data,
                    completion: { (url) in
                        
                        guard let imageUrl = url,
                            let uid = FirebaseManager.shared.currentUser?.uid else {return}
                        
                        FirebaseManager.shared.updateData(type: User.user.rawValue,
                                                              uid: uid,
                                                              key: User.logoImage.rawValue,
                                                              value: imageUrl)
                })
        }
        dismiss(animated: true, completion: nil)
    }
}
