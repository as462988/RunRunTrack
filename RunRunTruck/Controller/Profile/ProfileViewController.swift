//
//  TruckListViewController.swift
//  RunRunTruck
//
//  Created by yueh on 2019/8/30.
//  Copyright © 2019 yueh. All rights reserved.
//

import UIKit
import Firebase

class ProfileViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print("我出現了")
        
        Auth.auth().addStateDidChangeListener { (auth, user) in

            if user == nil {
                
                self.navigationController?.popToRootViewController(animated: false)
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if FirebaseManager.shared.bossID != nil {
//            guard let bossVc = UIStoryboard.profile.instantiateViewController(
//                withIdentifier: "BossInfoViewController") as? BossInfoViewController else { return }
            
            performSegue(withIdentifier: "bossInfo", sender: nil)
//            show(bossVc, sender: nil)
        } else if FirebaseManager.shared.userID != nil {
            guard let userVc = UIStoryboard.profile.instantiateViewController(
                withIdentifier: "UserInfoViewController") as? UserInfoViewController else { return }
            
            show(userVc, sender: nil)
        }
    }
    
}
