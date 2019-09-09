//
//  TruckListViewController.swift
//  RunRunTruck
//
//  Created by yueh on 2019/8/30.
//  Copyright © 2019 yueh. All rights reserved.
//

import UIKit

class ProfileViewController: UIViewController {
    
    @IBOutlet weak var clickLogoOutBtn: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        clickLogoOutBtn.layer.cornerRadius = 10
        clickLogoOutBtn.clipsToBounds = true

    }
    
    @IBAction func clickLogoOutBtn(_ sender: Any) {
        
        FirebaseManager.shared.signOut()
        
        let appdelegate = UIApplication.shared.delegate as? AppDelegate
        
        let root = appdelegate?.window?.rootViewController as? TabBarViewController
        
        root?.selectedIndex = 0

    }
}
