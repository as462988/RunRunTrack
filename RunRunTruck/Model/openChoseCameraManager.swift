
//
//  openChoseCameraManager.swift
//  RunRunTruck
//
//  Created by yueh on 2019/9/18.
//  Copyright © 2019 yueh. All rights reserved.
//

import Foundation
import UIKit

protocol openChoseCameraManagerDelegate: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
}
class OpenChoseCameraManager {
    
    weak var delegate: openChoseCameraManagerDelegate?
    
    func showImagePickerAlert(_ vc: UIViewController) {
        
        let imagePickerController = UIImagePickerController()
        
//       weak var delegate: openChoseCameraManagerDelegate?
        
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
}
