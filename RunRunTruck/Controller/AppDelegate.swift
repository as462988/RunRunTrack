//
//  AppDelegate.swift
//  RunRunTruck
//
//  Created by yueh on 2019/8/27.
//  Copyright © 2019 yueh. All rights reserved.
//

import UIKit
import Firebase
import GoogleMaps
import IQKeyboardManager
import UserNotifications
import FirebaseMessaging
import AuthenticationServices

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    // swiftlint:disable force_cast
    static let shared = UIApplication.shared.delegate as! AppDelegate
    // swiftlint:enable force_cast

    var window: UIWindow?

    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        FirebaseApp.configure()
        
        GMSServices.provideAPIKey(Bundle.ValueForString(key: Constant.googleMapKey))
        
        IQKeyboardManager.shared().isEnabled = true
        
        IQKeyboardManager.shared().shouldResignOnTouchOutside = true
        
        FirebaseManager.shared.listenAllTruckData()
        
        ///找回使用者
        if Keychain.currentUserIdentifier != "" {
            FirebaseManager.shared.getCurrentUserData(
            userType: .normalUser,
            userIdentifier: Keychain.currentUserIdentifier) { normalUserData in
                guard let normalUserData = normalUserData else {
                    FirebaseManager.shared.getCurrentUserData(
                    userType: .boss,
                    userIdentifier: Keychain.currentUserIdentifier) { (bossData) in
                        if let bossData = bossData {
                            // TODO: 如果老闆還沒新增餐車，要跳出新增餐車頁面
                            FirebaseManager.shared.setupCurrentUserDataWhenLoginSuccess(userData: bossData)
                        }
                    }
                    return
                }
                FirebaseManager.shared.setupCurrentUserDataWhenLoginSuccess(userData: normalUserData)
            }
        }
        handlerNotification(application: application)
        
        return true
    }

    func handlerNotification(application: UIApplication) {
        
        UNUserNotificationCenter.current().delegate = self
        
        Messaging.messaging().delegate = self
        
        let authOption: UNAuthorizationOptions = [.alert, .badge, .sound]
        
        UNUserNotificationCenter.current().requestAuthorization(
        options: authOption) { (_, _) in }
        
        application.registerForRemoteNotifications()
    }
    func applicationWillEnterForeground(_ application: UIApplication) {
        
        let appleIDProvider = ASAuthorizationAppleIDProvider()
        appleIDProvider.getCredentialState(forUserID: Keychain.currentUserIdentifier) { credentialState, error in
            switch credentialState {
            case .authorized:
                break
            case .notFound:
                break
            case .revoked:
                FirebaseManager.shared.signOut()
            case .transferred:
                fallthrough
            @unknown default:
                break
            }
        }
    }
}

extension AppDelegate: UNUserNotificationCenterDelegate {

    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                willPresent notification: UNNotification,
                                withCompletionHandler completionHandler: @escaping (
        UNNotificationPresentationOptions) -> Void) {
        completionHandler([.alert, .badge, .sound])
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                didReceive response: UNNotificationResponse,
                                withCompletionHandler completionHandler: @escaping () -> Void) {
        //執行點擊後要做的事情
        let userInfo = response.notification.request.content.userInfo
    
        guard let latString = userInfo["latitude"] as? String,
                let longString = userInfo["longitude"] as? String else { return }

        guard let rootVC = window?.rootViewController as? TabBarViewController,
            let navigationVc = rootVC.viewControllers?[0] as? UINavigationController else { return }
        
        if let lobbyVC = navigationVc.viewControllers[0] as? LobbyViewController {
            
            lobbyVC.reloadLobbyViewWithChangeLocation(lat: Double(latString)!, long: Double(longString)!, zoom: 15)
            
            rootVC.selectedIndex = 0
        }
        
        completionHandler()
    }
}

extension AppDelegate: MessagingDelegate {
    
    func messaging(_ messaging: Messaging, didReceive remoteMessage: MessagingRemoteMessage) {
          print("Received data message: \(remoteMessage.appData)")
      }
    
    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String) {

        print("token: \(fcmToken)")
    }
}
