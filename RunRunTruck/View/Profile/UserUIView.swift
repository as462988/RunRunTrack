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
    func clickSettingBtn()
}

class UserUIView: UIView {

    @IBOutlet weak var settingBtn: UIButton!
    @IBOutlet weak var logoImage: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var animationView: AnimationView!

    weak var delegate: UserUIViewDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        settingBtn.addTarget(self, action: #selector(clickSettingBtn), for: .touchUpInside)
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(choseUpLoadImage))
        animationView.addGestureRecognizer(tapGesture)
        
    }
    
    func setupValue(name: String, image: String? = nil) {
        
        logoImage.loadImage(image, placeHolder: UIImage.asset(.Icon_myLogo))
        nameLabel.text = name
    }
    
    func setLayout() {
        
        logoImage.layer.cornerRadius = logoImage.bounds.width / 2
        logoImage.contentMode = .scaleAspectFill
        logoImage.clipsToBounds = true
        logoImage.layer.borderWidth = 2
        logoImage.layer.borderColor = UIColor(red: 61/255, green: 61/255, blue: 61/255, alpha: 0.5).cgColor
        animationView.layer.cornerRadius = animationView.bounds.width / 2
        
    }
    
    @objc func choseUpLoadImage() {
        
        self.delegate?.clickUpLoadBtn()
    }
    
    @objc func clickSettingBtn() {
        self.delegate?.clickSettingBtn()
    }
}
