//
//  FirebaseStorageManager.swift
//  RunRunTruck
//
//  Created by yueh on 2019/9/18.
//  Copyright © 2019 yueh. All rights reserved.
//

import Foundation
import FirebaseStorage

class FirebaseStorageManager {
    
   static let shared = FirebaseStorageManager()
    
    let storageRef = Storage.storage().reference()
    // 上傳圖片
    func upLoadUserLogo(type: String, data: Data, completion: @escaping ((String)?) -> Void) {
        let uniqueString = NSUUID().uuidString
        let upLoadImageRef = storageRef.child("\(type)/\(uniqueString).jpg")
        let metadata = StorageMetadata()
        
        metadata.contentType = "image/jpeg"
        
        upLoadImageRef.putData(data, metadata: metadata) { (metadata, error) in
             guard error == nil else {
                completion(nil)
                return
                
            }
            
            upLoadImageRef.downloadURL(completion: { (url, error) in
                
                guard let downloadURL = url else {
                    
                    print("Uh-oh, an error occurred!")
                    return
                }
                
                print("Photo Url: \(downloadURL)")
                completion(downloadURL.absoluteString)
            })
        }

    }

    func deleteImageFile(type: String, imageName: String) {
        
        let desertRef = storageRef.child("\(type)/\(imageName).jpg")
        // Delete the file
        desertRef.delete { error in
            if let error = error {
                print(error)
            } else {
                print("delete success")
            }
        }
    }
}
