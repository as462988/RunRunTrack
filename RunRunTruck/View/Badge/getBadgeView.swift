//
//  getBadgeView.swift
//  RunRunTruck
//
//  Created by yueh on 2019/9/18.
//  Copyright © 2019 yueh. All rights reserved.
//

import UIKit

class GetBadgeView: UIView {

    let backgroundView: UIView = {
       let view = UIView(frame: CGRect(x: 0, y: 0,
                                       width: UIScreen.main.bounds.width,
                                       height: UIScreen.main.bounds.height))
        view.backgroundColor = .black
        view.alpha = 0.4
        return view
    }()

    var img = UIImageView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.addSubview(backgroundView)
        self.addSubview(img)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setImage(imageUrl: String) {
        img.loadImage(imageUrl, placeHolder: UIImage.asset(.Icon_logo))
        img.frame = CGRect(x: 0, y: 0, width: 300, height: 300)
        img.center = self.center
        img.layer.borderWidth = 5
        img.layer.borderColor = UIColor.lightGray.cgColor
        img.layer.cornerRadius = 150
        img.contentMode = .scaleAspectFill
        img.clipsToBounds = true
    }
    
    func animateAppear() {
        let group = CAAnimationGroup()
        group.beginTime = CACurrentMediaTime() + 1
        group.duration = 5
        group.fillMode = .backwards
        group.timingFunction = CAMediaTimingFunction(name: .easeOut)
        
        let scale = CASpringAnimation(keyPath: "transform.scale")
        scale.fromValue = 0.1
        scale.toValue = 1

        let border = CASpringAnimation(keyPath: "borderWidth")
        border.fromValue = 150
        border.toValue = 5

        group.animations = [scale, border]
        img.layer.add(group, forKey: nil)
    }
}
