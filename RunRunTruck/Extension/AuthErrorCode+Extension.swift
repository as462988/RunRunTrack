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
    
//    var errorMessage: String {
//        switch self {
//        case .emailAlreadyInUse:
//            return "The email is already in use with another account"
//        case .userNotFound:
//            return "Account not found for the specified user. Please check and try again"
//        case .userDisabled:
//            return "Your account has been disabled. Please contact support."
//        case .invalidEmail, .invalidSender, .invalidRecipientEmail:
//            return "Please enter a valid email"
//        case .networkError:
//            return "Network error. Please try again."
//        case .weakPassword:
//            return "Your password is too weak. The password must be 6 characters long or more."
//        case .wrongPassword:
//            return "Your password is incorrect. Please try again or use 'Forgot password' to reset your password"
//        default:
//            return "Unknown error occurred"
//        }
//    }
    
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
