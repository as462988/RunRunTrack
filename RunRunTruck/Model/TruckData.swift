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
    
    case truckId
    
    case name
    
    case open
    
    case logoImage
    
    case detailImage
    
    case story
    
    case openTime
    
    case location
    
    case chatRoom
    
    case favoritedBy
    
}

struct TruckData {
    
    var id: String
    
    let name: String
    
    let logoImage: String
    
    let detailImage: String?
    
    let open: Bool
    
    let story: String
    
    let openTime: Double?
    
    let location: GeoPoint?
    
    var address: String = ""
    
    var favoritedBy: Array<String> = []
    
    init(_ id: String, _ name: String,
         _ logoImage: String, _ detailImage: String?,
         _ story: String, _ open: Bool,
         _ openTime: Double?, _ location: GeoPoint?, _ favoritedBy: [String]) {
        self.id = id
        self.name = name
        self.logoImage = logoImage
        self.detailImage = detailImage
        self.open = open
        self.story = story
        self.openTime = openTime
        self.location = location
        self.favoritedBy = favoritedBy
    }
}

struct UserFavoriteTruck {
    
    var id: String
      
    let name: String
      
    let logoImage: String

    init(_ id: String, _ name: String, _ logoImage: String) {
    self.id = id
    self.name = name
    self.logoImage = logoImage
    }
}

struct Message {
    
    var uid: String
    var name: String
    var logoImage: String?
    var text: String
    var createTime: Double
    
    init(_ uid: String, _ name: String, _ logoImage: String? = nil, _ text: String, _ createTime: Double) {
        self.uid = uid
        self.name = name
        self.logoImage = logoImage
        self.text = text
        self.createTime = createTime
    }
}

enum User: String {
    
    case user = "User"
    
    case uid
    
    case name
    
    case email
    
    case logoImage
    
    case text
    
    case createTime
    
    case badge
    
    case block
    
    case favorite
}

struct UserData {
    
    let name: String
    
    let email: String
    
    let logoImage: String?
    
    let badge: [String]
    
    let truckId: String?
    
    let block: [String]
    
    let favorite: [String]
    
    init(name: String, email: String, logoImage: String? = nil,
         badge: [String] = [], truckId: String? = nil,
         block: [String] = [], favorite: [String] = [] ) {
        self.name = name
        self.email = email
        self.logoImage = logoImage
        self.badge = badge
        self.truckId = truckId
        self.block = block
        self.favorite = favorite
    }
}

enum Boss: String {
    
    case boss = "Boss"
    
    case uid
    
    case name
    
    case email
}

struct TruckShortInfo {
    
    let truckId: String
    
    let name: String
    
    let logoImage: String
    
    var isAchieved: Bool = false
    
    init(truckId: String, name: String, logoImage: String) {
        self.truckId = truckId
        self.name = name
        self.logoImage = logoImage
    }
}
