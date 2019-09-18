//
//  UserInfoViewController.swift
//  RunRunTruck
//
//  Created by yueh on 2019/9/11.
//  Copyright © 2019 yueh. All rights reserved.
//

import UIKit

class UserInfoViewController: UIViewController {

    @IBOutlet weak var userView: UserUIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        self.navigationController?.isNavigationBarHidden = true
        
        FirebaseManager.shared.getCurrentUserData { (userData) in
            
            guard let data = userData else {return}
            
            self.userView.setupValue(name: data.name)
        }
        
    }
}
