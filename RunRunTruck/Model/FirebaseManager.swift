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
    
    var openIngTruckData = [TruckData]()
    
    var currentUser: UserData?
    
    var bossTruck: TruckData?
    
    var message = [Message]()
    
    let db = Firestore.firestore()
    
    let storage = Storage.storage()
    
    var truckID: String?
    
    var userID: String?
    
    var bossID: String?
    
    // MARK: getOpeningTruck
    
    func getOpeningTruckData(completion: @escaping ([(TruckData, DocumentChangeType)]?) -> Void) {
        
        db.collection(Truck.truck.rawValue).whereField(
            Truck.open.rawValue, isEqualTo: true).addSnapshotListener { (snapshot, error) in
            
            guard let snapshot = snapshot else {
                print("Error fetching document: \(error!)")
                return
            }
            
                var rtnTruckDatas: [(TruckData, DocumentChangeType)] = []
            snapshot.documentChanges.forEach({ (documentChange) in
                let data = documentChange.document.data()

                guard let name = data[Truck.name.rawValue] as? String,
                    let logoImage = data[Truck.logoImage.rawValue] as? String,
                    let open = data[Truck.open.rawValue] as? Bool,
                    let story = data[Truck.story.rawValue] as? String,
                    let openTimestamp = data[Truck.openTime.rawValue] as? Double,
                    let location = data[Truck.location.rawValue] as? GeoPoint else {return}

                let truck = TruckData(documentChange.document.documentID,
                                      name, logoImage, story, open,
                                      openTimestamp, location)
                rtnTruckDatas.append((truck, documentChange.type))
            })
                completion(rtnTruckDatas)
        }
        
    }
    
    // MARK: getUserData
    func getCurrentUserData(completion: @escaping (UserData?) -> Void) {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        
        db.collection(User.user.rawValue).document(uid).getDocument { [weak self](snapshot, error) in
            
            guard let data = snapshot?.data() else {
                completion(nil)
                return
            }
            
            guard let name = data[User.name.rawValue] as? String,
                let email = data[User.email.rawValue] as? String else { return }
            
            self?.currentUser = UserData(name: name, email: email, truckId: nil)
            
            completion(self?.currentUser)
        }
    }
    
    func getCurrentBossData(completion: @escaping (UserData?) -> Void) {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        
        db.collection(Boss.boss.rawValue).document(uid).getDocument { [weak self](snapshot, error) in
            
            guard let data = snapshot?.data() else {
                completion(nil)
                return
            }
            
            guard let name = data[Boss.name.rawValue] as? String,
                let email = data[Boss.email.rawValue] as? String,
                let truckId = data[Truck.truckId.rawValue] as? String  else { return }
            
            self?.currentUser = UserData(name: name, email: email, truckId: truckId)
            
            completion(self?.currentUser)
        }
    }
    
    func  getBossTruck(completion: @escaping (TruckData?) -> Void) {
        
        guard let truckId = currentUser?.truckId else {
            completion(nil)
            return
        }
        
        db.collection(Truck.truck.rawValue).document(truckId).getDocument {(snapshot, error) in
            guard let snapshot = snapshot else {
                return
            }
            
            guard let name = snapshot.data()?[Truck.name.rawValue] as? String,
                let logoImage = snapshot.data()?[Truck.logoImage.rawValue] as? String,
                let open = snapshot.data()?[Truck.open.rawValue] as? Bool,
                let story = snapshot.data()?[Truck.story.rawValue] as? String
                else {return}
            
            self.bossTruck = TruckData(snapshot.documentID, name, logoImage, story, open, nil, nil)
           
            completion(self.bossTruck)
        }

    }
    
    // MARK: singUp
    func userRegister(email: String, psw: String, completion: @escaping () -> Void) {
        
        Auth.auth().createUser(withEmail: email, password: psw) {(authResult, error) in
            
            guard error == nil else {
                
                //TODO: 顯示無法註冊的原因
                print(AuthErrorCode(rawValue: error!._code)?.errorMessage ?? "nil")
                
                return
            }
            print("User Regiuter Success")
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
            }
        }
    }
    
    func setBossData(name: String, email: String) {
        
        guard let uid = Auth.auth().currentUser?.uid else { return }
        
        db.collection(Boss.boss.rawValue).document(uid).setData([
            Boss.name.rawValue: name,
            Boss.email.rawValue: email,
            Truck.truckId.rawValue: nil]
        ) { [weak self] error in
            
            if let error = error {
                print("Error adding document: \(error)")
            } else {
                
                self?.currentUser = UserData(name: name, email: email, truckId: nil)
                
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
            }
        }
    }
    
    func changeOpenStatus(status: Bool, lat: Double? = nil, lon: Double? = nil) {
        
        guard let truckId = bossTruck?.id else { return }
        
        if status {
            let location = GeoPoint(latitude: lat!, longitude: lon!)
            
            db.collection(Truck.truck.rawValue).document(truckId).updateData([
                Truck.open.rawValue: status,
                Truck.openTime.rawValue: Date().timeIntervalSince1970,
                Truck.location.rawValue: location
            ]) { (error) in
                if let err = error {
                    print("Error modify: \(err)")
                } else {
                    print("Status modify Success")
                }
            }
        } else {
            
            db.collection(Truck.truck.rawValue).document(truckId).updateData([
                Truck.open.rawValue: status
            ]) { (error) in
                if let err = error {
                    print("Error modify: \(err)")
                } else {
                    print("Status modify Success")
                }
            }
        }
    }
    
//    func closeOpenStatus(status: Bool) {
//
//        guard let truckId = bossTruck?.id else { return }
//
//        db.collection(Truck.truck.rawValue).document(truckId).updateData([
//            Truck.open.rawValue: status
//        ]) { (error) in
//            if let err = error {
//                print("Error modify: \(err)")
//            } else {
//                print("Status modify Success")
//            }
//        }
//    }
//
    func updataStoryText(text: String) {
        
        guard let truckId = bossTruck?.id else { return }
        
        db.collection(Truck.truck.rawValue).document(truckId).updateData([
            Truck.story.rawValue: text
            ]) { (error) in
                if let err = error {
                    print("Error modify: \(err)")
                } else {
                    print("Status modify Success")
                }
        }
    }
    
    // MARK: singIn
    func singInWithEmail(email: String, psw: String, completion: @escaping (_ isSuccess: Bool) -> Void) {
        
        Auth.auth().signIn(withEmail: email, password: psw) { (user, error) in
            
            guard error == nil else {
                //TODO: 顯示無法登入的原因
                print("didn't singIn")
                completion(false)
                return
            }
            
            print("Success")
            completion(true)
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
        
        db.collection(Truck.truck.rawValue).document(truckID).collection(
            Truck.chatRoom.rawValue).addDocument(data: [
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
