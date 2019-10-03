//
//  HandleSettingAlert.swift
//  RunRunTruck
//
//  Created by Yueh-chen Hsu on 2019/10/3.
//  Copyright © 2019 yueh. All rights reserved.
//

import Foundation
import UIKit

class HandleSettingAlert {
    
    func openSetting(title: String, msg: String, settingTitle: String, cancelTitle: String, vc: UIViewController) -> UIViewController {
        
        let alertController = UIAlertController(title: title, message: msg, preferredStyle: .alert)
          
          let settingsAction = UIAlertAction(title: settingTitle, style: .default) { (_) -> Void in
              
              guard let settingsUrl = URL(string: UIApplication.openSettingsURLString) else {
                  return
              }
              
              if UIApplication.shared.canOpenURL(settingsUrl) {
                  UIApplication.shared.open(settingsUrl, completionHandler: { (success) in
                  })
              }
          }
          alertController.addAction(settingsAction)
        let cancelAction = UIAlertAction(title: cancelTitle, style: .default) { (action) in
            
            vc.navigationController?.popViewController(animated: true)
            print("cancel")
        }
          alertController.addAction(cancelAction)
          
        return alertController
    }
}
