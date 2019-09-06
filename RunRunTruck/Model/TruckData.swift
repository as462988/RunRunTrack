//
//  TruckData.swift
//  RunRunTruck
//
//  Created by yueh on 2019/8/28.
//  Copyright © 2019 yueh. All rights reserved.
//

import Foundation
import Firebase

enum Truck: String {
    
    case truck = "Truck"
    
    case id
    
    case name
    
    case logoImage
    
    case openTime
    
    case closeTime
    
    case location
    
    case chatRoom
    
}

struct TruckData {
    
    let id: String
    
    let name: String
    
    let logoImage: String
    
    let openTime: Timestamp

    let closeTime: Timestamp
    
    let location: GeoPoint
    
    var address: String = ""
    
    init(_ id: String, _ name: String, _ logoImage: String,
         _ openTime: Timestamp, _ closeTime: Timestamp, _ location: GeoPoint) {
        self.id = id
        self.name = name
        self.logoImage = logoImage
        self.openTime = openTime
        self.closeTime = closeTime
        self.location = location
    }
}

//struct Message {
//
//    var uid: String
//    var name: String
//    var text: String
//    var createTime: Timestamp
//
//    init(_ uid: String, _ name: String, _ text: String, _ createTime: Timestamp) {
//        self.uid = uid
//        self.name = name
//        self.text = text
//        self.createTime = createTime
//    }
//}

struct Message {
    
    var uid: String
    var name: String
    var text: String
    var createTime: Int
    
    init(_ uid: String, _ name: String, _ text: String, _ createTime: Int) {
        self.uid = uid
        self.name = name
        self.text = text
        self.createTime = createTime
    }
}

enum User: String {
    
    case user = "User"
    
    case uid
    
    case name
    
    case email
    
    case text
    
    case createTime
}

struct UserData {
    
    let name: String
    
    let email: String
    
    init(name: String, email: String) {
        self.name = name
        self.email = email
    }
}
