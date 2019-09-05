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
        text.isEditable = false
        text.translatesAutoresizingMaskIntoConstraints = false
        return text
    }()
    
    let nameTextLabel: UILabel = {
        let text = UILabel()
        text.text = "Name"
        text.textColor = UIColor(r: 61, g: 61, b: 61)
        text.backgroundColor = .yellow
        text.font = UIFont.systemFont(ofSize: 16)
        text.backgroundColor = .clear
        text.translatesAutoresizingMaskIntoConstraints = false
        return text
    }()
    
    static let myMessageColor = UIColor(r: 61, g: 61, b: 61)
    
    let bubbleView: UIView = {
        let view = UIView()
        view.backgroundColor = myMessageColor
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 16
        view.layer.masksToBounds = true
        return view
    }()
    
    let profileImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage.asset(.Icon_UserImage)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.layer.cornerRadius = imageView.frame.width / 2
        imageView.layer.masksToBounds = true
        imageView.contentMode = ContentMode.scaleAspectFill
        return imageView
    }()
    
    var bubbleWidthAnchor: NSLayoutConstraint?
    var bubbleTrailingAnchor: NSLayoutConstraint?
    var bubbleLeadingAnchor: NSLayoutConstraint?
    var bubbleViewTopAnchor: NSLayoutConstraint?
    var bubbleViewTopAnchorWithName: NSLayoutConstraint?
    var bubbleViewHeightAnchor: NSLayoutConstraint?
    var bubbleViewheigHtAnchorWithName: NSLayoutConstraint?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.addSubview(bubbleView)
        self.addSubview(textView)
        self.addSubview(nameTextLabel)
        self.addSubview(profileImageView)
        setupLayout()
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemwnted")
    }
    
    func setupCellValue(text: String, name: String){
        textView.text = text
        nameTextLabel.text = name
    }
    
    func setupLayout() {
        
        NSLayoutConstraint.activate([
            
            nameTextLabel.leadingAnchor.constraint(equalTo: bubbleView.leadingAnchor),
            nameTextLabel.topAnchor.constraint(equalTo: self.topAnchor)
            ])
        
        NSLayoutConstraint.activate([
            
            profileImageView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 8),
            profileImageView.topAnchor.constraint(equalTo: self.topAnchor),
            profileImageView.widthAnchor.constraint(equalToConstant: 50),
            profileImageView.heightAnchor.constraint(equalToConstant: 50)
            ])
        
        // set bubble TopAnchor
        
        bubbleViewTopAnchor = bubbleView.topAnchor.constraint(equalTo: self.topAnchor)
        bubbleViewTopAnchor?.isActive = true
        
        bubbleViewTopAnchorWithName = bubbleView.topAnchor.constraint(equalTo: nameTextLabel.bottomAnchor, constant: 5)
        bubbleViewTopAnchorWithName?.isActive = false
        
        // set bubble WidthAnchor
        bubbleWidthAnchor = bubbleView.widthAnchor.constraint(equalToConstant: 200)
        bubbleWidthAnchor?.isActive = true
        
        // set bubble TrailingAnchor / LeadingAnchor
        bubbleTrailingAnchor = bubbleView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -8)
        bubbleTrailingAnchor?.isActive = true
        
        bubbleLeadingAnchor = bubbleView.leadingAnchor.constraint(equalTo: profileImageView.trailingAnchor, constant: 8)
        bubbleLeadingAnchor?.isActive = false
        
        // set bubble heightAnchor
       bubbleViewHeightAnchor = bubbleView.heightAnchor.constraint(equalTo: self.heightAnchor)
        bubbleViewHeightAnchor?.isActive = true
        
        bubbleViewheigHtAnchorWithName = bubbleView.heightAnchor.constraint(equalTo: self.heightAnchor, constant: -60)
       bubbleViewheigHtAnchorWithName?.isActive = false
        
    bubbleView.bottomAnchor.constraint(greaterThanOrEqualTo: self.bottomAnchor)
        
        NSLayoutConstraint.activate([
            textView.topAnchor.constraint(equalTo: bubbleView.topAnchor),
            textView.leadingAnchor.constraint(equalTo: bubbleView.leadingAnchor, constant: 8),
            textView.trailingAnchor.constraint(equalTo: bubbleView.trailingAnchor),
            textView.heightAnchor.constraint(equalTo: self.heightAnchor)
            ])
        
    }
    
}
