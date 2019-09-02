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

    }
    
    @IBAction func clickLogoOutBtn(_ sender: Any) {
        
        FirebaseManager.shared.signOut()
        
        let appdelegate = UIApplication.shared.delegate as? AppDelegate
        
        let root = appdelegate?.window?.rootViewController as? TabBarViewController
        
        root?.selectedIndex = 0

    }
}
