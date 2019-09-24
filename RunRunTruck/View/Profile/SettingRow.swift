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
        label.font = .systemFont(ofSize: 22)
        label.textColor = .darkGray
        return label
    }()
//    convenience init(type buttonType: UIButton.ButtonType) {
//        self.init(type: buttonType)
//        backgroundColor = .white
//        setupViews()
//
//    }
//
//    required init?(coder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
        
    func setupViews() {
        backgroundColor = .blue
//        translatesAutoresizingMaskIntoConstraints = false
//        self.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.width).isActive = true
//        self.heightAnchor.constraint(equalToConstant: 75).isActive = true
        self.addSubview(customTitleLabel)
        customTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        customTitleLabel.centerYAnchor.constraint(
            equalTo: self.centerYAnchor).isActive = true
        customTitleLabel.leadingAnchor.constraint(
            equalTo: self.leadingAnchor, constant: 20).isActive = true
//        let bottomLine = UIView()
//        self.addSubview(bottomLine)
//        bottomLine.backgroundColor = .lightGray
//        bottomLine.translatesAutoresizingMaskIntoConstraints = false
//        bottomLine.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 20).isActive = true
//        bottomLine.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
//        bottomLine.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
//        bottomLine.heightAnchor.constraint(equalToConstant: 1).isActive = true
    }
}
