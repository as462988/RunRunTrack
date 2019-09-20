//
//  UserInfoViewController.swift
//  RunRunTruck
//
//  Created by yueh on 2019/9/11.
//  Copyright © 2019 yueh. All rights reserved.
//

import UIKit

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
    
}

extension UserInfoViewController: UserUIViewDelegate {
    
    func clickUpLoadBtn() {
        openChoseCameraManager.showImagePickerAlert(self)
    }
}

extension UserInfoViewController: OpenChoseCameraManagerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController,
                               didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
        
        openChoseCameraManager.upLoadImage(image: userView.logoImage,
                                           info: info)
        dismiss(animated: true, completion: nil)
    }
}
