//
//  ChatRoomTableViewCell.swift
//  RunRunTruck
//
//  Created by yueh on 2019/9/3.
//  Copyright © 2019 yueh. All rights reserved.
//

import UIKit

class ChatMessageCell: UICollectionViewCell {
    
    let textView: UITextView = {
       let text = UITextView()
        text.textColor = .white
        text.font = UIFont.systemFont(ofSize: 16)
        text.backgroundColor = .clear
        text.translatesAutoresizingMaskIntoConstraints = false
        return text
    }()
    
    let bubbleView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(r: 61, g: 61, b: 61)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 16
        view.layer.masksToBounds = true
        return view
    }()
    
    var bubbleWidthAnchor: NSLayoutConstraint?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.addSubview(bubbleView)
        self.addSubview(textView)
        setupLayout()
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemwnted")
    }
    
    func setupLayout() {
        
        bubbleWidthAnchor = bubbleView.widthAnchor.constraint(equalToConstant: 200)
        
        NSLayoutConstraint.activate([
            
            bubbleView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -8),
            bubbleView.topAnchor.constraint(equalTo: self.topAnchor),
            bubbleWidthAnchor!,
            bubbleView.heightAnchor.constraint(equalTo: self.heightAnchor)
            ])
        
        NSLayoutConstraint.activate([
            
            textView.leadingAnchor.constraint(equalTo: bubbleView.leadingAnchor, constant: 8),
            textView.topAnchor.constraint(equalTo: self.topAnchor),
            textView.trailingAnchor.constraint(equalTo: bubbleView.trailingAnchor),
            textView.heightAnchor.constraint(equalTo: self.heightAnchor)
            ])
        
    }
    
}
