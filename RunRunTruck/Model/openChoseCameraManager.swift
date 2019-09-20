//
//  openChoseCameraManager.swift
//  RunRunTruck
//
//  Created by yueh on 2019/9/18.
//  Copyright © 2019 yueh. All rights reserved.
//

import Foundation
import UIKit

protocol OpenChoseCameraManagerDelegate: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
}
class OpenChoseCameraManager {
    
    weak var delegate: OpenChoseCameraManagerDelegate?
    
    func showImagePickerAlert(_ vc: UIViewController) {
        
        let imagePickerController = UIImagePickerController()
        
        imagePickerController.delegate = delegate
        
        let imagePickerAlertController = UIAlertController(
            title: "上傳圖片",
            message: "請選擇要上傳的圖片",
            preferredStyle: .actionSheet)
        
        let imageFromLibAction = UIAlertAction(title: "照片圖庫", style: .default) { (Void) in
            
            if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
                
                imagePickerController.sourceType = .photoLibrary
                vc.present(imagePickerController, animated: true, completion: nil)
            }
        }
        let imageFromCameraAction = UIAlertAction(title: "相機", style: .default) { (Void) in
            
            if UIImagePickerController.isSourceTypeAvailable(.camera) {
                
                imagePickerController.sourceType = .camera
                vc.present(imagePickerController, animated: true, completion: nil)
            }
        }
        
        let cancelAction = UIAlertAction(title: "取消", style: .cancel) { (Void) in
            
            imagePickerAlertController.dismiss(animated: true, completion: nil)
        }
        
        imagePickerAlertController.addAction(imageFromLibAction)
        imagePickerAlertController.addAction(imageFromCameraAction)
        imagePickerAlertController.addAction(cancelAction)
        
        vc.present(imagePickerAlertController, animated: true, completion: nil)
        
    }
    
//    func upLoadImage(image: UIImageView,
//                     info: [UIImagePickerController.InfoKey: Any],
//                     completion: @escaping ((Data, String)?) -> Void) {
//
//        var selectedImageFromPicker: UIImage?
//        let uniqueString = NSUUID().uuidString
//
//        if let pickedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
//
//            selectedImageFromPicker = pickedImage
//            image.image = selectedImageFromPicker
//        }
//
//        if var selectedImage = selectedImageFromPicker {
//
//            selectedImage = selectedImage.resizeImage(targetSize: CGSize(width: 400, height: 400))
//
//            guard let uploadData = selectedImage.pngData() else {return}
//
//            completion((uploadData, uniqueString))
//
//        }
//
//    }
    
    func upLoadImage(image: UIImageView,
                     info: [UIImagePickerController.InfoKey: Any],
                     completion: @escaping ((Data)?) -> Void) {
        
        var selectedImageFromPicker: UIImage?

        if let pickedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            
            selectedImageFromPicker = pickedImage
            image.image = selectedImageFromPicker
        }
        
        if var selectedImage = selectedImageFromPicker {
            
            selectedImage = selectedImage.resizeImage(targetSize: CGSize(width: 400, height: 400))
            
            guard let uploadData = selectedImage.pngData() else {return}
            
            completion((uploadData))
            
        }
        
    }
}
