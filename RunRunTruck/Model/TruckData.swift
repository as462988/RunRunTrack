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
}

struct TruckData {
    
    let id: String
    
    let name: String
    
    let logoImage: String
    
    let openTime: Timestamp

    let closeTime: Timestamp
    
    init(_ id: String, _ name: String, _ logoImage: String,
         _ openTime: Timestamp, _ closeTime: Timestamp) {
        self.id = id
        self.name = name
        self.logoImage = logoImage
        self.openTime = openTime
        self.closeTime = closeTime
    }
}
