//
//  BossUIView.swift
//  RunRunTruck
//
//  Created by yueh on 2019/9/10.
//  Copyright © 2019 yueh. All rights reserved.
//

import UIKit

class BossUIView: UIView {

    @IBOutlet weak var logoImage: UIImageView!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var story: UITextView!
    @IBOutlet weak var editBtn: UIButton!
    @IBOutlet weak var logoOutBtn: UIButton!
    @IBOutlet weak var openSwitch: UISwitch!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        logoOutBtn.addTarget(self, action: #selector(clickLogoutBtn), for: .touchUpInside)
        setRadius(btn: logoOutBtn)
        setRadius(btn: editBtn)
    }
    
    func setupValue() {
        
    }
    
    func setRadius(btn: UIButton) {
        btn.layer.cornerRadius = 10
        btn.clipsToBounds = true
    }
    
    @objc func clickLogoutBtn() {
        
        FirebaseManager.shared.signOut()
        
        let appDelegate = UIApplication.shared.delegate as? AppDelegate
        
        let root = appDelegate?.window?.rootViewController as? TabBarViewController
        
        root?.selectedIndex = 0
        
    }
}
