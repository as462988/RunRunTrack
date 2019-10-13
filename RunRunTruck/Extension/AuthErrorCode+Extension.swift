//
//  AuthErrorCode+Extension.swift
//  RunRunTruck
//
//  Created by yueh on 2019/9/2.
//  Copyright © 2019 yueh. All rights reserved.
//

import Foundation
import Firebase

extension AuthErrorCode {
    
    var errorMessage: String {
        
        switch self {
            
        case .emailAlreadyInUse:
            return "此帳號已使用過囉！"
            
        case .userNotFound:
            return "目前找不到此使用者，請確認輸入的帳號！"
            
        case .userDisabled:
            return "目前找不到此使用者，可以透過註冊加入會員喔！"
            
        case .invalidEmail, .invalidSender, .invalidRecipientEmail:
            return "此信箱無效，請重新輸入！"
            
        case .networkError:
            return "目前網路異常，請稍後再試"
            
        case .weakPassword:
            return "密碼太弱了（危險～）請輸入六位以上密碼！"
            
        case .wrongPassword:
            return "密碼輸入錯誤！請重新確認～"
            
        default:
            return "服務異常，請與我們聯絡。"
            
        }
    }
}
