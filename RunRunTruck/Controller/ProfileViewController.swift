//
//  TruckListViewController.swift
//  RunRunTruck
//
//  Created by yueh on 2019/8/30.
//  Copyright © 2019 yueh. All rights reserved.
//

import UIKit

class ProfileViewController: UIViewController {
    
    @IBOutlet weak var bossUIView: BossUIView!
    @IBOutlet weak var userUIView: UserUIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if FirebaseManager.shared.bossID == nil {
            userUIView.isHidden = false
            bossUIView.isHidden = true
        } else {
            userUIView.isHidden = true
            bossUIView.isHidden = false
        }
    }

}
