//
//  FirebaseNotificationManager.swift
//  RunRunTruck
//
//  Created by Yueh-chen Hsu on 2019/10/2.
//  Copyright © 2019 yueh. All rights reserved.
//

import Foundation
import Firebase
import FirebaseMessaging

private struct PostKey {
    static let toTopicKey = "to"
    static let topicValue = "/topics/"
    static let titleKey = "title"
    static let bodyKey = "body"
    static let notificationKey = "notification"
    static let dataKey = "data"
    static let lat = "latitude"
    static let lon = "longitude"
}

class FirebaseNotificationManager {
    
    static let share = FirebaseNotificationManager()
    
    // MARK: 訂閱
    func subscribeTopic(toTopic topic: String, completion: (() -> Void)?) {
        
        Messaging.messaging().subscribe(toTopic: topic) { (error) in
            guard let error = error else {
                print("\(topic) is success subscribe")
                completion?()
                return
            }
            print(error)
        }
    }
    
    func unSubscribeTopic(fromTopic topic: String, completion: (() -> Void)?) {
        
        Messaging.messaging().unsubscribe(fromTopic: topic) { (error) in
            guard let error = error else {
                print("success unsubscribe")
            completion?()
                return
            }
            print(error)
        }
    }

    func sendPushNotification(toTopic topic: String, title: String, body: String, latitude: Double, longitude: Double) {
        let urlString = Bundle.ValueForString(key: Constant.notificationURL)
        guard let url = NSURL(string: urlString) else {return}

        let paramString: [String: Any] = [PostKey.toTopicKey: PostKey.topicValue + topic,
                                          PostKey.notificationKey: [PostKey.titleKey: title,
                                                                    PostKey.bodyKey: body],
                                          PostKey.dataKey: [PostKey.lat: latitude,
                                                            PostKey.lon: longitude]
        ]
        
        let request = NSMutableURLRequest(url: url as URL)
        
        request.httpMethod = HTTPMethod.POST.rawValue
        
        request.httpBody = try? JSONSerialization.data(withJSONObject: paramString,
                                                       options: [.prettyPrinted])
        request.setValue(HTTPHeaderValue.json.rawValue, forHTTPHeaderField: HTTPHeaderField.contentType.rawValue)
        request.setValue(
            Bundle.ValueForString(key: Constant.ncRequestKey),
            forHTTPHeaderField: HTTPHeaderField.auth.rawValue)
        
        let task = URLSession.shared.dataTask(with: request as URLRequest) { (data, _, _) in
            do {
                if let jsonData = data {
                    if let jsonDataDict  = try JSONSerialization.jsonObject(
                        with: jsonData,
                        options: JSONSerialization
                            .ReadingOptions
                            .allowFragments)
                        as? [String: AnyObject] {
                        NSLog("Received data:\n\(jsonDataDict))")
                    }
                }
            } catch let err as NSError {
                print(err.debugDescription)
            }
        }
        task.resume()
    }
}
