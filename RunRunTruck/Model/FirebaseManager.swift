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
    
    var openIngTruckData: [TruckData] = []
    
    var currentUser: UserData?
    
    var message = [Message]()
    
    let db = Firestore.firestore()
    
    let storage = Storage.storage()
    
    var truckID: String?
    
    var userID: String?
    
    var bossID: String?
    
    static func dateConvertString(date: Date, dateFormat: String = "yyyy-MM-dd HH:mm:ss") -> String {
        let timeZone = TimeZone.init(identifier: "UTC")
        let formatter = DateFormatter()
        formatter.timeZone = timeZone
        formatter.locale = Locale.init(identifier: "zh_CN")
        formatter.dateFormat = dateFormat
        let date = formatter.string(from: date)
        return date.components(separatedBy: " ").first!
        }
    
    // MARK: 讀取 truckData
    func getTruckData(completion: @escaping ([TruckData]?) -> Void) {
        db.collection(Truck.truck.rawValue).getDocuments { (snapshot, error) in
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
                
                self.openIngTruckData.append(truck)
            }
            completion(self.openIngTruckData)
        }
        
    }
    
    // MARK: getOpeningTruck
    
    func getOpeningTruckData(completion: @escaping ([TruckData]?) -> Void) {
        db.collection(Truck.truck.rawValue).whereField(
            Truck.open.rawValue, isEqualTo: true).getDocuments { (snapshot, error) in
                
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
                    
                    self.openIngTruckData.append(truck)
                }
                completion(self.openIngTruckData)
                
        }
    }
    
    // MARK: getUserData
    func getCurrentUserData(completion: @escaping (UserData?) -> Void) {
         guard let uid = Auth.auth().currentUser?.uid else { return }
        
        db.collection(User.user.rawValue).document(uid).getDocument { [weak self](snapshot, error) in
            
            guard let snapshot = snapshot else {
                completion(nil)
                return
            }
            
            guard let name = snapshot.data()?[User.name.rawValue] as? String,
                let email = snapshot.data()?[User.email.rawValue] as? String else { return }
            
            self?.currentUser = UserData(name: name, email: email, truckId: nil)
            
            completion(self?.currentUser)
        }
    }
    
    func getCurrentBossData(completion: @escaping (UserData?) -> Void) {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        
        db.collection(Boss.boss.rawValue).document(uid).getDocument { [weak self](snapshot, error) in
            
            guard let snapshot = snapshot else {
                completion(nil)
                return
            }
            
            guard let name = snapshot.data()?[Boss.name.rawValue] as? String,
                let email = snapshot.data()?[Boss.email.rawValue] as? String,
                let truckId = snapshot.data()?[Truck.truckId.rawValue] as? String  else { return }
            
            self?.currentUser = UserData(name: name, email: email, truckId: truckId)
            
            completion(self?.currentUser)
        }
    }
    
    // MARK: singUp
    func userRegister(email: String, psw: String, completion: @escaping () -> Void) {
        
        Auth.auth().createUser(withEmail: email, password: psw) {(authResult, error) in

                guard error == nil else {
                    
                    //TODO: 顯示無法註冊的原因
                    let errorCode = AuthErrorCode(rawValue: error!._code)
                    print(errorCode?.errorMessage ?? "nil")
              
                    return
                }
                print("User Regiuter Success")
                completion()
        }
    }
    
    func bossRegister(email: String, psw: String, completion: @escaping () -> Void) {
        
        Auth.auth().createUser(withEmail: email, password: psw) { (bossResult, error) in
            guard error == nil else {
                
                //TODO: 顯示無法註冊的原因
                let errorCode = AuthErrorCode(rawValue: error!._code)
                print(errorCode?.errorMessage ?? "nil")
                
                return
            }
            
            print("Boss Regiuter Success")
            completion()
        }
    }

    // MARK: setData
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
    
    func setBossData(name: String, email: String) {
        
        guard let uid = Auth.auth().currentUser?.uid else { return }
        
        db.collection(Boss.boss.rawValue).document(uid).setData([
            Boss.name.rawValue: name,
            Boss.email.rawValue: email,
            Truck.truckId.rawValue: ""]
        ) { error in
            
            if let error = error {
                print("Error adding document: \(error)")
            } else {
                print("Document successfully written!")
            }
        }
        
    }
    
    func addTurck(name: String, img: String, story: String, completion: @escaping (String) -> Void) {
        
        var ref: DocumentReference?
        
        ref = db.collection(Truck.truck.rawValue).addDocument(data: [
            Truck.name.rawValue: name,
            Truck.logoImage.rawValue: img,
            Truck.story.rawValue: story,
            Truck.open.rawValue: false
            ], completion: { (error) in
                if let err = error {
                    print("Error adding document: \(err)")
                } else {
                    print("Document added with ID: \(ref!.documentID)")
                }
        })
        
        completion(ref!.documentID)
    }
    
    func addTurckIDInBoss(truckId: String) {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        
        db.collection(Boss.boss.rawValue).document(uid).updateData([
            Truck.truckId.rawValue: truckId
        ]) { (error) in
            if let err = error {
                print("Error adding document: \(err)")
            } else {
                print("Document added with")
            }
        }
    }

    // MARK: singIn
    func singInWithEmail(email: String, psw: String, completion: @escaping () -> Void) {

        Auth.auth().signIn(withEmail: email, password: psw) {[weak self](user, error) in

            guard error == nil else {
                //TODO: 顯示無法登入的原因
                print("didn't singIn")
                return
            }

            print("Success")
            self?.userID = Auth.auth().currentUser?.uid
            completion()
        }
    }
    
    func bossSingIn(email: String, psw: String, completion: @escaping () -> Void) {
        
        Auth.auth().signIn(withEmail: email, password: psw) {[weak self](user, error) in
            
            guard error == nil else {
                //TODO: 顯示無法登入的原因
                print("didn't singIn")
                return
            }
            
            print("Success")
            self?.bossID = Auth.auth().currentUser?.uid
            completion()
        }
    }
    // MARK: - signOut
    func signOut() {
       
        let firebaseAuth = Auth.auth()
        
        do {
            try firebaseAuth.signOut()
            
            self.userID = nil
            self.bossID = nil
            
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
    
    // MARK: - creatChatRoom
    func creatChatRoom(truckID: String, truckName: String, uid: String, name: String, text: String) {

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
    
    // MARK: - show ChatRoom Message
    func observeMessage(truckID: String, completion: @escaping ([Message]) -> Void) {
        
            let docRef = db.collection(Truck.truck.rawValue).document(truckID)
        
            let order = docRef.collection(Truck.chatRoom.rawValue).order(
                by: User.createTime.rawValue,
                descending: false)
        
            order.addSnapshotListener { (snapshot, error) in
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
                
                if documentChange.type == .added {
                    
                    rtnMessage.append(Message(uid, name, text, createTime))
                
                }
            })
            if rtnMessage.count > 0 {
                completion(rtnMessage)
            }
        }
    }
}
