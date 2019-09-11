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
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var storyTextView: UITextView!
    @IBOutlet weak var editBtn: UIButton!
    @IBOutlet weak var logoOutBtn: UIButton!
    @IBOutlet weak var openSwitch: UISwitch!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setRadius()
        logoOutBtn.addTarget(self, action: #selector(clickLogoutBtn), for: .touchUpInside)
    
    }
    
    func setupValue() {
        
        guard let data = FirebaseManager.shared.bossTruck else {return}
        
        nameLabel.text = data.name
        storyTextView.text = data.story
    }
    
    func cleanValue() {
        nameLabel.text = ""
        storyTextView.text = ""
    }
    
    func setRadius() {
        
        editBtn.layer.cornerRadius = 10
        editBtn.clipsToBounds = true
        logoOutBtn.layer.cornerRadius = 10
        logoOutBtn.clipsToBounds = true
        storyTextView?.layer.cornerRadius = 10
        storyTextView?.clipsToBounds = true
        
    }
    
    @objc func clickLogoutBtn() {
        
        FirebaseManager.shared.signOut()
        
        let appDelegate = UIApplication.shared.delegate as? AppDelegate
        
        let root = appDelegate?.window?.rootViewController as? TabBarViewController
        
        root?.selectedIndex = 0
        
        cleanValue()
    }
}
