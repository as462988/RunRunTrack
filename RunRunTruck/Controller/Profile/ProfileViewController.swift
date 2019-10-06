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

        Auth.auth().addStateDidChangeListener { (auth, user) in
            
            if user == nil {
                
                self.navigationController?.popToRootViewController(animated: false)
            }
        }
        self.navigationController?.isNavigationBarHidden = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        super.viewWillAppear(animated)
        
        guard let currentUser = FirebaseManager.shared.currentUser else { return }
        
        if currentUser.type == .boss {
            //老闆
            if let bossVC =
                UIStoryboard.profile.instantiateViewController(
                    withIdentifier: String(describing: BossInfoViewController.self)) as? BossInfoViewController {
                
                self.navigationController?.pushViewController(bossVC, animated: false)
            }
        } else if currentUser.type == .normalUser {
            
            if let userVc =
                UIStoryboard.profile.instantiateViewController(
                    withIdentifier: String(describing: UserInfoViewController.self)) as? UserInfoViewController {
                
                self.navigationController?.pushViewController(userVc, animated: false)
            }
            
        }
    }
}
