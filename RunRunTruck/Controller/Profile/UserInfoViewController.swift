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
        
        FirebaseManager.shared.getCurrentUserData { (userData) in
            
            guard let data = userData else {return}
            
            self.userView.setupValue(name: data.name)
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
                data: uploadData) { [weak self] (url) in
                    
                    guard let imageUrl = url else {return}
                    
                    self?.userView.logoImage.loadImage(imageUrl)
            }
            
        }
        
        dismiss(animated: true, completion: nil)
        
    }
}
