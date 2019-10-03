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

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    // swiftlint:disable force_cast
    static let shared = UIApplication.shared.delegate as! AppDelegate
    var token: String = ""
    // swiftlint:enable force_cast

    var window: UIWindow?

    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        FirebaseApp.configure()
        
        GMSServices.provideAPIKey(Bundle.ValueForString(key: Constant.googleMapKey))
        
        IQKeyboardManager.shared().isEnabled = true
        IQKeyboardManager.shared().shouldResignOnTouchOutside = true
        FirebaseManager.shared.listenAllTruckData()
        
        UNUserNotificationCenter.current().delegate = self
        Messaging.messaging().delegate = self
        
        return true
    }

    func handlerNotfication(application: UIApplication) {
        let authOption: UNAuthorizationOptions = [.alert, .badge, .sound]
        UNUserNotificationCenter.current().requestAuthorization(
        options: authOption) { (_, _) in
        }
        application.registerForRemoteNotifications()
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
        
        let latString = userInfo["latitude"] as? String
        let lonString = userInfo["longitude"] as? String
        let lat = Double(latString!)
        let lon = Double(lonString!)
        
        guard let lobbyVC = UIStoryboard.lobby.instantiateViewController(
            identifier: String(describing: LobbyViewController.self)) as? LobbyViewController else { return }
    
        lobbyVC.centerLat = lat ?? 0.0
        lobbyVC.centeyLon = lon ?? 0.0
        
        let root = window?.rootViewController as? TabBarViewController
        root?.selectedIndex = 0
        
        completionHandler()
    }
}

extension AppDelegate: MessagingDelegate {
    
    func messaging(_ messaging: Messaging, didReceive remoteMessage: MessagingRemoteMessage) {
          print("Received data message: \(remoteMessage.appData)")
      }
    
    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String) {

        FirebaseManager.shared.currentUserToken = fcmToken
        print("token: \(fcmToken)")
    }
}
