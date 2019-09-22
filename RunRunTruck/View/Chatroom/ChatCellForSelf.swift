//
//  ChatCellForOthers.swift
//  RunRunTruck
//
//  Created by yueh on 2019/9/8.
//  Copyright © 2019 yueh. All rights reserved.
//

import UIKit

class ChatCellForSelf: ChatMessageCell {
    
    override func createProfileBgImageView() -> UIImageView? { return nil }
    override func createNameLabel() -> UILabel? { return nil }
    override func createUserImageView() -> UIImageView? { return nil }
    override func configureTextView() {
        super.configureTextView()
        
        textView.textColor = .white
        textView.backgroundColor = .clear
    }
    
    override func configureBubbleView() {
        super.configureBubbleView()
        bubbleView.backgroundColor = UIColor(r: 61, g: 61, b: 61)
    }
    override func setupLayout() {

        bubbleView.topAnchor.constraint(equalTo: self.topAnchor, constant: 4).isActive = true
        bubbleView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -8).isActive = true
        bubbleView.widthAnchor.constraint(lessThanOrEqualToConstant: 200).isActive = true
        bubbleHeightAnchor = bubbleView.heightAnchor.constraint(equalToConstant: 1)
        bubbleHeightAnchor?.isActive = true

        //聊天文字
        textView.topAnchor.constraint(equalTo: bubbleView.topAnchor, constant: 5).isActive = true
        textView.leadingAnchor.constraint(equalTo: bubbleView.leadingAnchor, constant: 4).isActive = true
        textView.trailingAnchor.constraint(equalTo: bubbleView.trailingAnchor).isActive = true
        textView.heightAnchor.constraint(equalTo: bubbleView.heightAnchor, constant: -5).isActive = true
    }
}
