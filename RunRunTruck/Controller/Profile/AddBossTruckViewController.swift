//
//  AddBossTruckViewController.swift
//  RunRunTruck
//
//  Created by yueh on 2019/9/10.
//  Copyright © 2019 yueh. All rights reserved.
//

import UIKit

class AddBossTruckViewController: UIViewController {
    
    @IBOutlet weak var truckTextInput: UITextView!
    @IBOutlet weak var showLogoImage: UIImageView!
    @IBOutlet weak var clickSendBtn: UIButton!
    @IBOutlet weak var upLoadImage: UIButton!
    
    var logoImageUrl: String?
    
    let openChoseCamera = OpenChoseCameraManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setLayout()
        openChoseCamera.delegate = self
  
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    }
    
    func setLayout() {
        
        clickSendBtn.layer.cornerRadius = 20
        clickSendBtn.layer.masksToBounds = true
        
        showLogoImage.layer.cornerRadius = showLogoImage.frame.width / 2
        showLogoImage.layer.masksToBounds = true
        showLogoImage.layer.borderWidth = 1
        showLogoImage.layer.borderColor = UIColor.gray.cgColor
        showLogoImage.contentMode = .scaleAspectFill
        showLogoImage.clipsToBounds = true
        
    }
    
    @IBAction func upLoadImageBtn(_ sender: Any) {
        showImagePickerAlert()
    }
    
    func showImagePickerAlert() {
        
        openChoseCamera.showImagePickerAlert(self)
        
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

extension AddBossTruckViewController: openChoseCameraManagerDelegate {

    func imagePickerController(_ picker: UIImagePickerController,
                               didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
        
        var selectedImageFromPicker: UIImage?
        let uniqueString = NSUUID().uuidString
        
        if let pickedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
         
            selectedImageFromPicker = pickedImage
            showLogoImage.image = selectedImageFromPicker
        }
        
        if let selectedImage = selectedImageFromPicker {
            
            guard let uploadData = selectedImage.pngData() else {return}
            
             FirebaseStorageManager.shared.upLoadTruckLogo(
                imageName: uniqueString,
                data: uploadData) { [weak self] (url) in
                    
                    guard let imageUrl = url else {return}
                    
                    self?.logoImageUrl = imageUrl
            }
            
        }
        
        dismiss(animated: true, completion: nil)
    }
    
}
