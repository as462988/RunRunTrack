//
//  UserUIView.swift
//  RunRunTruck
//
//  Created by yueh on 2019/9/10.
//  Copyright © 2019 yueh. All rights reserved.
//

import UIKit
import Lottie

protocol UserUIViewDelegate: AnyObject {
    func clickUpLoadBtn()
}

class UserUIView: UIView {

    @IBOutlet weak var logoOutBtn: UIButton!
    @IBOutlet weak var logoImage: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var animationView: AnimationView!
    
    weak var delegate: UserUIViewDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        logoOutBtn.addTarget(self, action: #selector(clickLogoutBtn), for: .touchUpInside)
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(choseUpLoadImage))
        animationView.addGestureRecognizer(tapGesture)
        
    }
    
    func setupValue(name: String, image: String? = nil) {
        
        logoImage.loadImage(image, placeHolder: UIImage.asset(.Icon_logo))
        nameLabel.text = name
    }
    
    func setLayout() {
        
        logoImage.layer.cornerRadius = logoImage.bounds.width / 2
        logoImage.contentMode = .scaleAspectFill
        logoImage.clipsToBounds = true
        animationView.layer.cornerRadius = animationView.bounds.width / 2
        logoOutBtn.clipsToBounds = true
        logoOutBtn.layer.cornerRadius = 10
        logoOutBtn.clipsToBounds = true
        
    }
    
    @objc func clickLogoutBtn() {
        
        FirebaseManager.shared.signOut()
        
        let appDelegate = UIApplication.shared.delegate as? AppDelegate
        
        let root = appDelegate?.window?.rootViewController as? TabBarViewController
        
        root?.selectedIndex = 0
    }
    
    @objc func choseUpLoadImage() {
        
        self.delegate?.clickUpLoadBtn()
    }
}
