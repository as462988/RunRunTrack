//
//  File.swift
//  RunRunTruck
//
//  Created by yueh on 2019/9/24.
//  Copyright © 2019 yueh. All rights reserved.
//

import Foundation
import AuthenticationServices

struct AppleUser {
    
    let id: String
    
    let firstName: String
    
    let lastName: String
    
    let email: String

    init(credentials: ASAuthorizationAppleIDCredential) {
        
        self.id = credentials.user
        self.firstName = credentials.fullName?.givenName ?? ""
        self.lastName = credentials.fullName?.familyName ?? ""
        self.email = credentials.email ?? ""
        
    }
    
    func defaultDisplayName() -> String {
        
        var returnName = ""
        if firstName != "" { returnName += "\(firstName), " }
        if lastName != "" { returnName += lastName }
        if returnName == "" { returnName = "你的名稱" }
        return returnName
        
    }
}
