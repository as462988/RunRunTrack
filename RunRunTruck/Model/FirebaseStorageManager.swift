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
    func upLoadUserLogo(imageName: String, data: Data, completion: @escaping ((String)?) -> Void) {
        
        let upLoadImageRef = storageRef.child("\(imageName).jpg")
        
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
    
    // 將圖片傳回 dataBase
    
    func setImageToDataBase() {
        
    }
    
}
