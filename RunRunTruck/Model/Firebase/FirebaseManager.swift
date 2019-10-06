//
//  FirebaseManager.swift
//  RunRunTruck
//
//  Created by yueh on 2019/8/28.
//  Copyright © 2019 yueh. All rights reserved.
//

import Foundation
import FirebaseFirestore
import FirebaseAuth

// swiftlint:disable type_body_length
// swiftlint:disable file_length
class FirebaseManager {
    
    static let userNotificationName = "userInfoUpdatedNotification"
    static let allTruckDataNotificationName = "allTruckDataUpdatedNotification"
    
    static let shared = FirebaseManager()
    
    var openIngTruckData = [TruckData]()
    
    var allTruckData = [TruckData]()
    
    var currentUser: UserData?
    
    var bossTruck: TruckData?
    
    var message = [Message]()
        
    let db = Firestore.firestore()
    
    var truckID: String?
    
//    var userID: String?
//
//    var bossID: String?
    
    var userListener: ListenerRegistration?
    
    var allTruckDatasListener: ListenerRegistration?
    
    var openTruckDatasListener: ListenerRegistration?
    
    var messagesListener: ListenerRegistration?
    
    // MARK: About Truck
    
    ///監聽所有餐車資料變更
    func listenAllTruckData() {
        allTruckDatasListener = db.collection(Truck.truck.rawValue).addSnapshotListener { (snapshot, error) in
            guard error == nil else { return }
            var openTimestamp: Double?
            var location: GeoPoint?
            var detailImage: String?
            
            snapshot?.documentChanges.forEach({ (documentChange) in
                
                if documentChange.type == .added {
                    
                    let data = documentChange.document.data()
                    
                    guard let name = data[Truck.name.rawValue] as? String,
                        let logoImage = data[Truck.logoImage.rawValue] as? String,
                        let open = data[Truck.open.rawValue] as? Bool,
                        let story = data[Truck.story.rawValue] as? String,
                        let favorited = data[Truck.favoritedBy.rawValue] as? [String] else {return}
                    
                    openTimestamp = data[Truck.openTime.rawValue] as? Double
                    
                    location = data[Truck.location.rawValue] as? GeoPoint
                    
                    detailImage = data[Truck.detailImage.rawValue] as? String
                    
                    let truck = TruckData(documentChange.document.documentID,
                                          name, logoImage,
                                          detailImage,
                                          story,
                                          open,
                                          openTimestamp,
                                          location,
                                          favorited)
                    
                    self.allTruckData.append(truck)
                }
            })
            
            NotificationCenter.default.post(
                name: Notification.Name(FirebaseManager.allTruckDataNotificationName),
                object: nil)
        }
    }
    
    ///監聽營業中餐車資料
    func getOpeningTruckData(isOpen: Bool, completion: @escaping ([(TruckData, DocumentChangeType)]?) -> Void) {
        
        var openTimestamp: Double?
        
        var location: GeoPoint?
        
        var detailImage: String?
        
        openTruckDatasListener = db.collection(Truck.truck.rawValue).whereField(
            Truck.open.rawValue, isEqualTo: isOpen).addSnapshotListener { (snapshot, error) in
                
                guard let snapshot = snapshot else { return }
                
                var rtnTruckDatas: [(TruckData, DocumentChangeType)] = []
                
                snapshot.documentChanges.forEach({ (documentChange) in
                    
                    let data = documentChange.document.data()
                    
                    guard let name = data[Truck.name.rawValue] as? String,
                        let logoImage = data[Truck.logoImage.rawValue] as? String,
                        let open = data[Truck.open.rawValue] as? Bool,
                        let story = data[Truck.story.rawValue] as? String,
                        let favorited = data[Truck.favoritedBy.rawValue] as? [String] else {return}
                    
                    openTimestamp = data[Truck.openTime.rawValue] as? Double
                    
                    location = data[Truck.location.rawValue] as? GeoPoint
                    
                    detailImage = data[Truck.detailImage.rawValue] as? String
                    
                    let truck = TruckData(documentChange.document.documentID,
                                          name, logoImage,
                                          detailImage,
                                          story,
                                          open,
                                          openTimestamp,
                                          location,
                                          favorited)
                    
                    rtnTruckDatas.append((truck, documentChange.type))
                })
                completion(rtnTruckDatas)
        }
        
    }
    
    func addTruck(name: String, img: String, story: String, completion: @escaping (String) -> Void) {
        
        let ref = db.collection(Truck.truck.rawValue).document()
        
        ref.setData([
            Truck.truckId.rawValue: ref.documentID,
            Truck.name.rawValue: name,
            Truck.logoImage.rawValue: img,
            Truck.story.rawValue: story,
            Truck.open.rawValue: false,
            Truck.favoritedBy.rawValue: []
        ]) { (error) in
            if let err = error {
                print("Error adding document: \(err)")
            }
        }
        
        completion(ref.documentID)
    }
    
    func changeOpenStatus(status: Bool, lat: Double? = nil, lon: Double? = nil) {
        
        guard let truckId = bossTruck?.id else { return }
        
        if status {
            
            guard let lat = lat, let lon = lon else { return }
            
            let location = GeoPoint(latitude: lat, longitude: lon)
            
            db.collection(Truck.truck.rawValue).document(truckId).updateData([
                Truck.open.rawValue: status,
                Truck.openTime.rawValue: Date().timeIntervalSince1970,
                Truck.location.rawValue: location
            ])
        } else {
            
            db.collection(Truck.truck.rawValue).document(truckId).updateData([
                Truck.open.rawValue: status
            ])
        }
    }
    
    func getTruckId(truckName: String) {
        
        db.collection(Truck.truck.rawValue).whereField(
            Truck.name.rawValue,
            isEqualTo: truckName).getDocuments {[weak self] (snapshot, error) in
                
                guard let snapshot = snapshot else { return }
                
                for document in snapshot.documents {
                    self?.truckID = document.documentID
                    
                }
        }
    }
    
    // MARK: About All
    func updateData(type: String, uid: String, key: String, value: String) {
        
        db.collection(type).document(uid).updateData([ key: value ])
    }
    
    func updateArrayData(type: String, id: String, key: String, value: String, completion: @escaping () -> Void) {
        
        db.collection(type).document(id).updateData([key: FieldValue.arrayUnion([value])]) { (error) in
            
            if let error = error {
                print("Error adding document: \(error)")
            } else {
                completion()
            }
        }
    }
    
    func updateRemoveArrayData(type: String, id: String, key: String, value: String, completion: @escaping () -> Void) {
        db.collection(type).document(id).updateData([key: FieldValue.arrayRemove([value])]) { (error) in
            
            if let error = error {
                print("Error adding document: \(error)")
            } else {
                completion()
            }
        }
    }
    
    // MARK: About User

    ///獲取一次性的使用者資料
    func getCurrentUserData(userType: UserType, userIdentifier: String, completion: @escaping (UserData?) -> Void) {
        
        var mainPath = ""
        
        switch userType {
        case .boss:
            mainPath = User.boss.rawValue
        case .normalUser:
            mainPath = User.user.rawValue
        }
        db.collection(mainPath).document(userIdentifier).getDocument { [ weak self ] (snapshot, error) in
            guard let dataDic = snapshot?.data() else {
                completion(nil)
                return
            }
            completion(self?.getUserDataFromDataDic(userType: userType, dataDic: dataDic))
        }
    }
    
    ///監聽使用者資資料變更
    func listenCurrenUserData() {
        //判斷是否有使用者
        guard let currentUser = currentUser, let type = currentUser.type else { return }
        var mainPath = ""
        switch type {
        case .boss:
            mainPath = User.boss.rawValue
        case .normalUser:
            mainPath = User.user.rawValue
        }
        //監聽
        let doc = db.collection(mainPath).document(currentUser.uid)
        
        userListener = doc.addSnapshotListener { [weak self] (snapshot, error) in
            guard let dataDic = snapshot?.data() else { return }
            //拿到資料了
            self?.currentUser = self?.getUserDataFromDataDic(userType: type, dataDic: dataDic)
            NotificationCenter.default.post(name: Notification.Name(FirebaseManager.userNotificationName), object: nil)
        }
    }
    
    ///建立一筆一般使用者資料
    func setNormalUserData(name: String, email: String, userIdentifier: String, completion: @escaping (Bool) -> Void) {
        db.collection(User.user.rawValue).document(userIdentifier).setData([
            User.uid.rawValue: userIdentifier,
            User.name.rawValue: name,
            User.email.rawValue: email,
            User.badge.rawValue: [],
            User.block.rawValue: [],
            User.favorite.rawValue: []
        ]) { error in
             completion(error == nil)
        }
    }
    
    ///建立一筆Boss資料
    func setBossData(name: String, email: String, userIdentifier: String, completion: @escaping (Bool) -> Void) {
        db.collection(User.boss.rawValue).document(userIdentifier).setData([
            User.uid.rawValue: userIdentifier,
            User.name.rawValue: name,
            User.email.rawValue: email,
            User.badge.rawValue: []
        ]) { error in
            completion(error == nil)
        }
    }
    
    ///拿到一次性使用者的名字
    func getBlockUserName(blockId: String, completion: @escaping (String?) -> Void) {
        db.collection(User.user.rawValue).document(blockId).getDocument { (snapshot, error) in
            
            guard let data = snapshot?.data() else {
                completion(nil)
                return
            }
            
            guard let name = data[User.name.rawValue] as? String else {
                completion(nil)
                return
            }
            
            completion(name)
        }
    }
    
    func getUserFavoriteTruck(truckId: String, completion: @escaping (TruckShortInfo?) -> Void) {
        
        db.collection(Truck.truck.rawValue).document(truckId).getDocument { (snapshot, error) in
            
            guard let data = snapshot?.data() else {
                print("Document data was empty.")
                completion(nil)
                return
            }
            guard let truckId = data[Truck.truckId.rawValue] as? String,
                let name = data[Truck.name.rawValue] as? String,
                let logoImage = data[Truck.logoImage.rawValue] as? String else {return }
            
            let truck = TruckShortInfo(truckId: truckId, name: name, logoImage: logoImage)
            
            completion(truck)
        }
    }
    
    // MARK: About Boss
    
    func getBossTruck(completion: @escaping (TruckData?) -> Void) {
        
        var detailImage: String?
        
        guard let truckId = currentUser?.truckId else {
            
            completion(nil)
            
            return
        }
        
        db.collection(Truck.truck.rawValue).document(truckId).getDocument {(snapshot, error) in
            
            guard let snapshot = snapshot else { return }
            
            guard let name = snapshot.data()?[Truck.name.rawValue] as? String,
                let logoImage = snapshot.data()?[Truck.logoImage.rawValue] as? String,
                let open = snapshot.data()?[Truck.open.rawValue] as? Bool,
                let story = snapshot.data()?[Truck.story.rawValue] as? String,
                let favoritedBy = snapshot.data()?[Truck.favoritedBy.rawValue] as? [String]
                else {return}
            
            detailImage = snapshot.data()?[Truck.detailImage.rawValue] as? String
            
            self.bossTruck = TruckData(snapshot.documentID,
                                       name, logoImage, detailImage,
                                       story, open, nil, nil, favoritedBy)
            
            completion(self.bossTruck)
        }
        
    }
    
    func addTruckIDInBoss(isAppleSingIn: Bool, appleID: String? = nil, truckId: String) {
        
        guard isAppleSingIn  else {
            
            guard let uid = Auth.auth().currentUser?.uid else { return }
            
            db.collection(User.boss.rawValue).document(uid).updateData([
                
                Truck.truckId.rawValue: truckId
                
            ])
            
            return
        }
        
        db.collection(User.boss.rawValue).document(appleID!).updateData([
            Truck.truckId.rawValue: truckId
        ])
    }
    
    // MARK: About Register/SingIn
    func userRegister(email: String, psw: String, completion: @escaping (_ isSuccess: Bool, String) -> Void) {
    
        Auth.auth().createUser(withEmail: email, password: psw) {(authResult, error) in
            guard error == nil else {

                guard let errorCode = AuthErrorCode(rawValue: error!._code) else { return }
                
                completion(false, errorCode.errorMessage)
                
                return
            }
            completion(true, "Success")
        }
    }
    
    func singInWithEmail(email: String, psw: String, completion: @escaping (_ isSuccess: Bool, String) -> Void) {
        
        Auth.auth().signIn(withEmail: email, password: psw) { (user, error) in
            
            guard error == nil else {
                
                guard let errorCode = AuthErrorCode(rawValue: error!._code) else {return}
                completion(false, errorCode.errorMessage)
                return
            }
            
            completion(true, "Success")
        }
    }
    
    func signOut() {

        try? Auth.auth().signOut()
        
        self.removeCurrentUserWhenLogOut()
    }
    
    func checkExistUser(userType: String, uid: String, completion: @escaping (Bool) -> Void) {
        
        db.collection(userType).document(uid).getDocument { (snapshot, error) in
            
            guard snapshot?.data() != nil else {
                
                completion(false)
                
                return
            }
            
            completion(true)
        }
    }
    // MARK: About ChatRoom
    
    func createChatRoom(truckID: String, uid: String, name: String, image: String?, text: String) {
        
        db.collection(Truck.truck.rawValue).document(truckID).collection(
            Truck.chatRoom.rawValue).addDocument(data: [
                Truck.name.rawValue: name,
                User.uid.rawValue: uid,
                User.logoImage.rawValue: image,
                User.text.rawValue: text,
                User.createTime.rawValue: Date().timeIntervalSince1970
            ])
    }
    
    func deleteChatRoom(truckID: String) {
        
        let collection = db.collection(Truck.truck.rawValue).document(truckID).collection(Truck.chatRoom.rawValue)
        
        collection.getDocuments { (snapshot, error) in
            
            guard let snapshot = snapshot else {return}
            
            let docs = snapshot.documents
            
            for doc in docs {
                
                collection.document(doc.documentID).delete()
                
            }
        }
    }
    
    func observeMessage(truckID: String, completion: @escaping ([Message]) -> Void) {
        
        let docRef = db.collection(Truck.truck.rawValue).document(truckID)
        
        let order = docRef.collection(Truck.chatRoom.rawValue).order(
            by: User.createTime.rawValue,
            descending: false)
        
        messagesListener = order.addSnapshotListener { (snapshot, error) in
            
            guard let snapshot = snapshot else { return }
            
            var rtnMessage: [Message] = []
            
            var image: String?
            
            snapshot.documentChanges.forEach({ (documentChange) in
                
                let data = documentChange.document.data()
                
                guard let uid = data[User.uid.rawValue] as? String,
                    let name = data[User.name.rawValue] as? String,
                    let text = data[User.text.rawValue] as? String,
                    let createTime = data[User.createTime.rawValue] as? Double else {return}
                
                image = data[User.logoImage.rawValue] as? String
                
                if documentChange.type == .added {
                    
                    rtnMessage.append(Message(uid, name, image, text, createTime))
                }
            })
            
            if rtnMessage.count > 0 {
                
                completion(rtnMessage)
                
            }
        }
    }
    
    func createFeedback(user: String, uid: String, title: String, detailText: String) {
        
        db.collection(user).document(uid).collection(Feedback.feedback.rawValue).addDocument(data: [
            
            Feedback.title.rawValue: title,
            Feedback.detailText.rawValue: detailText,
            User.createTime.rawValue: Date().timeIntervalSince1970
            
        ])
    }
}

// MARK: Login / LogOut

extension FirebaseManager {
    
    func setupCurrentUserDataWhenLoginSuccess(userData: UserData) {
        currentUser = userData
        listenCurrenUserData()
        if let uid = currentUser?.uid {
            Keychain.setCurrentUserIdentifier(uid)
        }
        registerNotificationWhenFavoriteTrucksOpen()
    }
    
    func removeCurrentUserWhenLogOut() {
        currentUser = nil
        Keychain.deleteCurrentUserIdentifier()
        unregisterNotificationWhenFavoriteTrucksOpen()
        userListener?.remove()
    }
    
    ///註冊當前所有喜愛餐車的開業推播
    func registerNotificationWhenFavoriteTrucksOpen() {
        if let currentUser = currentUser {
            if currentUser.type == .normalUser {
                //註冊喜愛餐車推播
                for truckId in currentUser.favorite {
                    FirebaseNotificationManager.share.subscribeTopic(toTopic: truckId, completion: nil)
                }
            }
        }
    }
    ///取消註冊當前所有喜愛餐車的開業推播
    func unregisterNotificationWhenFavoriteTrucksOpen() {
        if let currentUser = currentUser {
            if currentUser.type == .normalUser {
                //註冊喜愛餐車推播
                for truckId in currentUser.favorite {
                    FirebaseNotificationManager.share.unSubscribeTopic(fromTopic: truckId, completion: nil)
                }
            }
        }
    }
    
}

// MARK: Utility methods

extension FirebaseManager {
    private func getUserDataFromDataDic(userType: UserType, dataDic: [String: Any]) -> UserData? {
        
        switch userType {
            
        case .boss:
            guard
                let uid = dataDic[User.uid.rawValue] as? String,
                let name = dataDic[User.name.rawValue] as? String,
                let email = dataDic[User.email.rawValue] as? String,
                let badge = dataDic[User.badge.rawValue] as? [String],
                let truckId = dataDic[Truck.truckId.rawValue] as? String else { return nil }
            return UserData(uid: uid, name: name, email: email, badge: badge, truckId: truckId, type: .boss)
            
        case .normalUser:
            guard
                let uid = dataDic[User.uid.rawValue] as? String,
                let name = dataDic[User.name.rawValue] as? String,
                let email = dataDic[User.email.rawValue] as? String,
                let badge = dataDic[User.badge.rawValue] as? [String],
                let block = dataDic[User.block.rawValue] as? [String],
                let favorite = dataDic[User.favorite.rawValue] as? [String] else { return nil }
            let image = dataDic[User.logoImage.rawValue] as? String ?? nil
            return UserData(uid: uid, name: name, email: email,
                            logoImage: image, badge: badge, block: block,
                            favorite: favorite, type: .normalUser)
        }
    }
}
