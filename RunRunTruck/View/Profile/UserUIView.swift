//
//  UserUIView.swift
//  RunRunTruck
//
//  Created by yueh on 2019/9/10.
//  Copyright © 2019 yueh. All rights reserved.
//

import UIKit

class UserUIView: UIView {

 @IBOutlet weak var logoOutBtn: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()

        logoOutBtn.addTarget(self, action: #selector(clickLogoutBtn), for: .touchUpInside)
    }
    
    @objc func clickLogoutBtn() {
        
        FirebaseManager.shared.signOut()
        
        let appDelegate = UIApplication.shared.delegate as? AppDelegate
        
        let root = appDelegate?.window?.rootViewController as? TabBarViewController
        
        root?.selectedIndex = 0
        
    }
}
