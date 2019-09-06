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
    
    var currentUser: UserData?
    
    var message = [Message]()
    
    let db = Firestore.firestore()
    
    let storage = Storage.storage()
    
    var truckID: String?
    
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
    func getTruckData(completion: @escaping ([TruckData]?) -> Void) {
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
    func setUserData(name: String, email: String) {
        
        guard let uid = Auth.auth().currentUser?.uid else { return }
        
        db.collection(User.user.rawValue).document(uid).setData([
            User.name.rawValue: name,
            User.email.rawValue: email]
        ) { error in
            
            if let error = error {
                print("Error adding document: \(error)")
            } else {
                print("Document successfully written!")
            }
        }
    }
    
    //getUserData
    func getCurrentUserData(completion: @escaping (UserData?) -> Void) {
         guard let uid = Auth.auth().currentUser?.uid else { return }
        
        db.collection(User.user.rawValue).document(uid).getDocument { [weak self](snapshot, error) in
            
            guard let snapshot = snapshot else {
                completion(nil)
                return
            }
            
            guard let name = snapshot.data()?[User.name.rawValue] as? String,
                let email = snapshot.data()?[User.email.rawValue] as? String else { return }
            
            self?.currentUser = UserData(name: name, email: email)
            
            completion(self?.currentUser)
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
    
    func getTruckId(truckName: String) {

        db.collection(Truck.truck.rawValue).whereField(
            Truck.name.rawValue,
            isEqualTo: truckName).getDocuments {[weak self] (snapshot, error) in
           
            guard error == nil else {
                print("Error getting documents")
                return
            }
                
                for document in snapshot!.documents {
                   self?.truckID = document.documentID
                    
            }
        }

    }
    
    //creatChatRoom
    func creatChatRoom(truckID: String, truckName: String, uid: String, name: String, text: String) {

//        guard let truckID = self.truckID else {return}
    db.collection(Truck.truck.rawValue).document(truckID).collection(Truck.chatRoom.rawValue).addDocument(data: [
            Truck.name.rawValue: name,
            User.uid.rawValue: uid,
            User.text.rawValue: text,
            User.createTime.rawValue: Date().timeIntervalSince1970
        ]) { (error) in

            if let err = error {
                print("Error writing document: \(err)")
            } else {
                print("Document successfully written!")
            }
        }
    }
    
    //show ChatRoom Message
    func observeMessage(truckID: String, completion: @escaping ([Message]) -> Void) {

       let ref = db.collection(Truck.truck.rawValue).document(truckID).collection(Truck.chatRoom.rawValue)
        ref.addSnapshotListener { (snapshot, error) in
            guard let snapshot = snapshot else {
                print("Error fetching document: \(error!)")
                return
            }
            var rtnMessage: [Message] = []

            snapshot.documentChanges.forEach({ (documentChange) in
                
                let data = documentChange.document.data()
                guard let uid = data[User.uid.rawValue] as? String,
                    let name = data[User.name.rawValue] as? String,
                    let text = data[User.text.rawValue] as? String,
                    let createTime = data[User.createTime.rawValue] as? Double else {return}
                
                switch documentChange.type {
                    
                case .added:
                    
                    rtnMessage.append(Message(uid, name, text, createTime))
                    
                    print("added: \(text)")
                    
                case .modified: print("modified: \(text)")
                    
                case .removed: print("removed: \(text)")
                @unknown default:
                    fatalError()
                }
                
            })
            if rtnMessage.count > 0 {
                completion(rtnMessage)
            }
        }
    }
    
    func getMessage(truckID: String, completion: @escaping ([Message]?) -> Void) {
        var rtnMessages: [Message] = []
        db.collection(Truck.truck.rawValue).document(truckID).collection(Truck.chatRoom.rawValue)
            .getDocuments { (data, err) in
                guard err == nil else {
                    completion(nil)
                    return
                }
                data?.documents.forEach({ (snapShot) in
                    guard let uid = snapShot[User.uid.rawValue] as? String,
                        let name = snapShot[User.name.rawValue] as? String,
                        let text = snapShot[User.text.rawValue] as? String,
                        let createTime = snapShot[User.createTime.rawValue] as? Double else {
                            return
                    }
                    rtnMessages.append(Message(uid, name, text, createTime))
                })
                completion(rtnMessages.count > 0 ? rtnMessages : nil)
        }
    }
}
