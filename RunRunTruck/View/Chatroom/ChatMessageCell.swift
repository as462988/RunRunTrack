//
//  ChatRoomTableViewCell.swift
//  RunRunTruck
//
//  Created by yueh on 2019/9/3.
//  Copyright © 2019 yueh. All rights reserved.
//

import UIKit

class ChatMessageCell: UICollectionViewCell {
    static let avatarImgWidth: CGFloat = 50
    static let avatarImgHeight: CGFloat = 50
    static let usrNameLabelHeight: CGFloat = 20
    static let userNameLabelWidth: CGFloat = 100
    
    let textView: UITextView = {
        let textView = UITextView()
        textView.textColor = .white
        textView.font = UIFont.systemFont(ofSize: 16)
        textView.backgroundColor = .black
        textView.isEditable = false
        textView.isScrollEnabled = false
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.layer.cornerRadius = 6
        textView.textContainer.lineFragmentPadding = 0
        textView.textContainerInset = .zero
        return textView
    }()
    
    let nameTextLabel: UILabel = {
        let text = UILabel()
        text.textColor = UIColor(r: 61, g: 61, b: 61)
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
    
    var textViewWidthAnchor: NSLayoutConstraint?
    var textViewHeightAnchor: NSLayoutConstraint?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.addSubview(profileImageView)
        self.addSubview(nameTextLabel)
//        self.addSubview(bubbleView)
        self.addSubview(textView)
        setupLayout()
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemwnted")
    }
    
    func setupCellValue(text: String, name: String) {
        textView.text = text
        nameTextLabel.text = name
    }
    
    func setupLayout() {
        profileImageView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 8).isActive = true
        profileImageView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        profileImageView.widthAnchor.constraint(equalToConstant: ChatMessageCell.avatarImgWidth).isActive = true
        profileImageView.heightAnchor.constraint(equalToConstant: ChatMessageCell.avatarImgHeight).isActive = true
        //名稱
        nameTextLabel.leadingAnchor.constraint(equalTo: profileImageView.trailingAnchor, constant: 4).isActive = true
        nameTextLabel.topAnchor.constraint(equalTo: profileImageView.topAnchor).isActive = true
        nameTextLabel.heightAnchor.constraint(equalToConstant: ChatMessageCell.usrNameLabelHeight).isActive = true
        nameTextLabel.widthAnchor.constraint(equalToConstant: ChatMessageCell.userNameLabelWidth).isActive = true
        //聊天文字
        textView.topAnchor.constraint(equalTo: nameTextLabel.bottomAnchor, constant: 4).isActive = true
        textView.leadingAnchor.constraint(equalTo: nameTextLabel.leadingAnchor).isActive = true
//        textView.bottomAnchor.constraint(greaterThanOrEqualTo: self.bottomAnchor, constant: -4).isActive = true
//        textView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -4).isActive = true
//        textView.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        textView.widthAnchor.constraint(lessThanOrEqualToConstant: 200).isActive = true
        textViewHeightAnchor = textView.heightAnchor.constraint(equalToConstant: 1)
        textViewHeightAnchor?.isActive = true
//        textViewWidthAnchor?.isActive = true
    }
    
//    func setupLayout() {
//
//        NSLayoutConstraint.activate([
            //個人照
//            profileImageView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 8),
//            profileImageView.topAnchor.constraint(equalTo: self.topAnchor),
//            profileImageView.widthAnchor.constraint(equalToConstant: 50),
//            profileImageView.heightAnchor.constraint(equalToConstant: 50),
//            //名稱
//            nameTextLabel.leadingAnchor.constraint(equalTo: profileImageView.trailingAnchor, constant: 4),
//            nameTextLabel.topAnchor.constraint(equalTo: profileImageView.topAnchor),
//            //聊天文字
//            textView.topAnchor.constraint(equalTo: nameTextLabel.bottomAnchor, constant: 4),
//            textView.leadingAnchor.constraint(equalTo: nameTextLabel.leadingAnchor),
//            textView.widthAnchor.constraint(lessThanOrEqualToConstant: 200),
//            textView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -4)
//            textView.
                        
//            ])
        
//        bubbleWidthAnchor = bubbleView.widthAnchor.constraint(equalToConstant: 200)
//        bubbleWidthAnchor?.isActive = true
        
//    }
    
//    func setupLayout() {
//        NSLayoutConstraint.activate([
//            profileImageView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 8),
//            profileImageView.topAnchor.constraint(equalTo: self.topAnchor),
//            profileImageView.widthAnchor.constraint(equalToConstant: 50),
//            profileImageView.heightAnchor.constraint(equalToConstant: 50)
//            ])
//
//        NSLayoutConstraint.activate([
//            nameTextLabel.leadingAnchor.constraint(equalTo: profileImageView.trailingAnchor, constant: 4),
//            nameTextLabel.topAnchor.constraint(equalTo: profileImageView.topAnchor)
//            ])
//
//
//        // set bubble TopAnchor
//
////        bubbleViewTopAnchor = bubbleView.topAnchor.constraint(equalTo: self.topAnchor)
////        bubbleViewTopAnchor?.isActive = true
//
//        bubbleViewTopAnchorWithName = bubbleView.topAnchor.constraint(equalTo: nameTextLabel.bottomAnchor, constant: 5)
//        bubbleViewTopAnchorWithName?.isActive = false
//
//        // set bubble WidthAnchor
//        bubbleWidthAnchor = bubbleView.widthAnchor.constraint(equalToConstant: 200)
//        bubbleWidthAnchor?.isActive = true
//
//        // set bubble TrailingAnchor / LeadingAnchor
//        bubbleTrailingAnchor = bubbleView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -8)
//        bubbleTrailingAnchor?.isActive = true
//
//        bubbleLeadingAnchor = bubbleView.leadingAnchor.constraint(equalTo: profileImageView.trailingAnchor, constant: 8)
//        bubbleLeadingAnchor?.isActive = false
//
//        // set bubble heightAnchor
//        bubbleViewHeightAnchor = bubbleView.heightAnchor.constraint(equalTo: self.heightAnchor)
//        bubbleViewHeightAnchor?.isActive = true
//
//        bubbleViewheigHtAnchorWithName = bubbleView.heightAnchor.constraint(equalTo: self.heightAnchor, constant: -60)
//        bubbleViewheigHtAnchorWithName?.isActive = false
//
//        NSLayoutConstraint.activate([
//            textView.topAnchor.constraint(equalTo: bubbleView.topAnchor),
//            textView.leadingAnchor.constraint(equalTo: bubbleView.leadingAnchor, constant: 8),
//            textView.trailingAnchor.constraint(equalTo: bubbleView.trailingAnchor),
//            textView.heightAnchor.constraint(equalTo: self.heightAnchor)
//            ])
//
//    }
    
}
