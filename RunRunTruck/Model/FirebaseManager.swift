//
//  FirebaseManager.swift
//  RunRunTruck
//
//  Created by yueh on 2019/8/28.
//  Copyright © 2019 yueh. All rights reserved.
//

import Foundation
import Firebase
import FirebaseFirestore
import FirebaseStorage

class FirebaseManager {
    
    static let shared = FirebaseManager()
    
    var truckData: [TruckData] = []
    
    let db = Firestore.firestore()
    
    let storage = Storage.storage()
    
    var userID: String?
    
    static func dateConvertString(date: Date, dateFormat: String = "yyyy-MM-dd HH:mm:ss") -> String {
        let timeZone = TimeZone.init(identifier: "UTC")
        let formatter = DateFormatter()
        formatter.timeZone = timeZone
        formatter.locale = Locale.init(identifier: "zh_CN")
        formatter.dateFormat = dateFormat
        let date = formatter.string(from: date)
        return date.components(separatedBy: " ").first!
        }
    
    //讀取 truckData
    func getTruckData(completion: @escaping ([TruckData]?) -> Void ) {
        db.collection(Truck.truck.rawValue).getDocuments { (snapshot, error)  in
            guard let snapshot = snapshot else {
                completion(nil)
                return
            }
    
            for document in snapshot.documents {
                
                guard let name = document.data()[Truck.name.rawValue] as? String,
                    let logoImage = document.data()[Truck.logoImage.rawValue] as? String,
                    let openTimestamp = document.data()[Truck.openTime.rawValue] as? Timestamp,
                    let closeTimestamp = document.data()[Truck.closeTime.rawValue] as? Timestamp,
                let location = document.data()[Truck.location.rawValue] as? GeoPoint else {return}
             
                let truck = TruckData(document.documentID, name, logoImage,
                                      openTimestamp, closeTimestamp, location)
                
                self.truckData.append(truck)
            }
            completion(self.truckData)
        }
        
    }
    
    //setUserData
    
    func setUserData(email: String) {
        
        guard let uid = Auth.auth().currentUser?.uid else { return }
        
        db.collection("User").document(uid).setData(["email": email]) { error in
            
            if let error = error {
                print("Error adding document: \(error)")
            } else {
                print("Document successfully written!")
            }
        }
    }
    
    // singUp
    func singUpWithEmail(email: String, psw: String, completion: @escaping () -> Void) {
        
        Auth.auth().createUser(withEmail: email, password: psw) {(authResult, error) in

                guard error == nil else {
                    
                    //todo 顯示無法註冊的原因
                    let errorCode = AuthErrorCode(rawValue: error!._code)
                    print(errorCode?.errorMessage ?? "nil")
              
                    return
                }
                print("Success")
                completion()
        }
    }
    
     // singIn
    func singInWithEmail(email: String, psw: String, completion: @escaping () -> Void) {

        Auth.auth().signIn(withEmail: email, password: psw) {[weak self](user, error) in

            guard error == nil else {
                print("didn't singIn")
                return
            }

            print("Success")
            self?.userID = Auth.auth().currentUser?.uid
            completion()
        }
    }
    
    func signOut() {
       
        let firebaseAuth = Auth.auth()
        
        do {
            try firebaseAuth.signOut()
            
            self.userID = nil
            
        } catch let signOutError as NSError {
            
            print ("Error signing out: %@", signOutError)
        }
    }
}
