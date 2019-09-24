//
//  SettingRow.swift
//  RunRunTruck
//
//  Created by yueh on 2019/9/24.
//  Copyright © 2019 yueh. All rights reserved.
//

import UIKit

class SettingRow: UIButton {
    var customTitleLabel: UILabel = {
       let label = UILabel()
        label.font = .systemFont(ofSize: 24)
        label.textColor = .darkGray
        return label
    }()
    
    var subTitleLabel: UILabel = {
       let label = UILabel()
        label.font = .systemFont(ofSize: 24)
        label.textColor = .darkGray
        return label
    }()
    
    var withRightArrow: Bool!
    
    init(title: String, subTitle: String?, withRightArrow: Bool) {
        self.customTitleLabel.text = title
        self.subTitleLabel.text = subTitle
        self.withRightArrow = withRightArrow
        super.init(frame: .zero)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
        
    func setupViews() {
        guard let superView = superview else {
            return
        }
        translatesAutoresizingMaskIntoConstraints = false
        self.leadingAnchor.constraint(equalTo: superView.leadingAnchor).isActive = true
        self.trailingAnchor.constraint(equalTo: superView.trailingAnchor).isActive = true
        self.heightAnchor.constraint(equalToConstant: 80).isActive = true

        self.addSubview(customTitleLabel)
        customTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        customTitleLabel.centerYAnchor.constraint(
            equalTo: self.centerYAnchor).isActive = true
        customTitleLabel.leadingAnchor.constraint(
            equalTo: self.leadingAnchor, constant: 20).isActive = true
        
        if withRightArrow {
            //這裡可以改為圖片比較漂亮
            let rightArrow = UILabel()
            rightArrow.font = .boldSystemFont(ofSize: 24)
            rightArrow.text = "〉"
            rightArrow.textColor = .lightGray
            self.addSubview(rightArrow)
            rightArrow.translatesAutoresizingMaskIntoConstraints = false
            rightArrow.centerYAnchor.constraint(
                equalTo: customTitleLabel.centerYAnchor).isActive = true
            rightArrow.trailingAnchor.constraint(
                equalTo: self.trailingAnchor, constant: -10).isActive = true
        }
        
        self.addSubview(subTitleLabel)
        subTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        subTitleLabel.centerYAnchor.constraint(
            equalTo: customTitleLabel.centerYAnchor).isActive = true
        subTitleLabel.trailingAnchor.constraint(
            equalTo: self.trailingAnchor, constant: -10).isActive = true

        let bottomLine = UIView()
        self.addSubview(bottomLine)
        bottomLine.backgroundColor = .lightGray
        bottomLine.translatesAutoresizingMaskIntoConstraints = false
        bottomLine.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 20).isActive = true
        bottomLine.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        bottomLine.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
        bottomLine.heightAnchor.constraint(equalToConstant: 0.5).isActive = true
    }
}
