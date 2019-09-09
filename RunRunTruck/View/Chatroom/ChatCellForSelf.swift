//
//  ChatCellForOthers.swift
//  RunRunTruck
//
//  Created by yueh on 2019/9/8.
//  Copyright © 2019 yueh. All rights reserved.
//

import UIKit

class ChatCellForSelf: ChatMessageCell {
    
    override func createProfileInmageView() -> UIImageView? { return nil }
    override func createNameLabel() -> UILabel? { return nil }
    
    override func configureTextView() {
        super.configureTextView()
        
        textView.textColor = .white
        textView.backgroundColor = UIColor(r: 61, g: 61, b: 61)
    }
    override func setupLayout() {
        //修改constrain
        
        textView.topAnchor.constraint(equalTo: self.topAnchor, constant: 4).isActive = true
        textView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -8).isActive = true
        textView.widthAnchor.constraint(lessThanOrEqualToConstant: 200).isActive = true
        
        textViewHeightAnchor = textView.heightAnchor.constraint(equalToConstant: 1)
        textViewHeightAnchor?.isActive = true
    }
}
