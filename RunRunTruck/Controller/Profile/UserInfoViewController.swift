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
            
            if data.image == nil {
            
            self.userView.setupValue(name: data.name)
                
            } else {
                self.userView.setupValue(name: data.name, image: data.image)
            }
        }
    }
    
}

extension UserInfoViewController: UserUIViewDelegate {
    
    func clickUpLoadBtn() {
        openChoseCameraManager.showImagePickerAlert(self)
    }
}

extension UserInfoViewController: openChoseCameraManagerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController,
                               didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
        
        var selectedImageFromPicker: UIImage?
        let uniqueString = NSUUID().uuidString
        
        if let pickedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            
            selectedImageFromPicker = pickedImage
            userView.logoImage.image = selectedImageFromPicker
        }
        
        if let selectedImage = selectedImageFromPicker {
            
            guard let uploadData = selectedImage.pngData() else {return}
            
            FirebaseStorageManager.shared.upLoadTruckLogo(
                imageName: uniqueString,
                data: uploadData) { (url) in
                    
                    guard let imageUrl = url else {return}
                    
                    FirebaseManager.shared.updataUserImage(image: imageUrl)
            }
            
        }
        
        dismiss(animated: true, completion: nil)
        
    }
}
