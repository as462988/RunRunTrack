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
    @IBOutlet weak var logoImage: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setLayout()
        logoOutBtn.addTarget(self, action: #selector(clickLogoutBtn), for: .touchUpInside)
    }
    
    func setupValue(name: String, image: String? = nil) {
        
        logoImage.loadImage(image, placeHolder: UIImage.asset(.Icon_logo))
        nameLabel.text = name
    }
    
    func setLayout() {
        
        logoImage.layer.cornerRadius = UIScreen.main.bounds.width / 3 / 2
        logoImage.clipsToBounds = true
        logoImage.contentMode = .scaleAspectFill
        
        logoOutBtn.layer.cornerRadius = 10
        logoOutBtn.clipsToBounds = true
        
    }
    
    @objc func clickLogoutBtn() {
        
        FirebaseManager.shared.signOut()
        
        let appDelegate = UIApplication.shared.delegate as? AppDelegate
        
        let root = appDelegate?.window?.rootViewController as? TabBarViewController
        
        root?.selectedIndex = 0
        
    }
}
