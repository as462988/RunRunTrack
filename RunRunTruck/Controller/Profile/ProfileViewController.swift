//
//  TruckListViewController.swift
//  RunRunTruck
//
//  Created by yueh on 2019/8/30.
//  Copyright © 2019 yueh. All rights reserved.
//

import UIKit

class ProfileViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print("我出現了")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if FirebaseManager.shared.bossID != nil {
            guard let bossVc = UIStoryboard.profile.instantiateViewController(
                withIdentifier: "BossInfoViewController") as? BossInfoViewController else { return }
            
            show(bossVc, sender: nil)
        } else if FirebaseManager.shared.userID != nil {
            guard let userVc = UIStoryboard.profile.instantiateViewController(
                withIdentifier: "UserInfoViewController") as? UserInfoViewController else { return }
            
            show(userVc, sender: nil)
        }
    }
}
