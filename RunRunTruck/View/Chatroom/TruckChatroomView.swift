//
//  TruckChatroomView.swift
//  RunRunTruck
//
//  Created by yueh on 2019/9/6.
//  Copyright © 2019 yueh. All rights reserved.
//

import UIKit

protocol TruckChatroomViewDelegate:
UICollectionViewDelegate,
UICollectionViewDataSource,
AnyObject {
    
}

class ChatRoomView: UIView {
    
    weak var delegate: TruckChatroomViewDelegate? {
        
        didSet {
            msgCollectionView.delegate = self.delegate
            msgCollectionView.dataSource = self.delegate
        }
    }
    
    var msgCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.contentInset = UIEdgeInsets(top: 8, left: 0, bottom: 8, right: 0)
        collectionView.backgroundColor = .white

        collectionView.translatesAutoresizingMaskIntoConstraints = false
        return collectionView
    }()
    
    let containerView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 10
        view.layer.masksToBounds = true
        return view
    }()
    
    let sendBtn: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage.asset(.Icon_button), for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    let sendTextBtn: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Send", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    let inputTextField: UITextField = {
        let text = UITextField()
        text.placeholder = "Enter Message"
        text.translatesAutoresizingMaskIntoConstraints = false
        return text
    }()
    
    let separatorLineView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(r: 220, g: 220, b: 220)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    var alertText: UILabel = {
        let text = UILabel()
        text.translatesAutoresizingMaskIntoConstraints = false
        text.textColor = UIColor(r: 61, g: 61, b: 61)
        text.textAlignment = .center
        return text
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.backgroundColor = .white
        self.addSubview(containerView)
        self.addSubview(msgCollectionView)
        self.addSubview(alertText)
        
        msgCollectionView.delegate = self.delegate
        msgCollectionView.dataSource = self.delegate
        setupInputComponents()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupInputComponents() {
        
        //msgCollectionView
        NSLayoutConstraint.activate([
            msgCollectionView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            msgCollectionView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            msgCollectionView.topAnchor.constraint(equalTo: self.topAnchor),
            msgCollectionView.bottomAnchor.constraint(equalTo: containerView.topAnchor),
        
        //inputContainerView
            containerView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            containerView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            containerView.bottomAnchor.constraint(equalTo: self.safeAreaLayoutGuide.bottomAnchor),
            containerView.heightAnchor.constraint(equalToConstant: 60),
            
            alertText.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            alertText.bottomAnchor.constraint(equalTo: self.containerView.topAnchor, constant: -10),
            alertText.widthAnchor.constraint(equalTo: self.widthAnchor)
            ])
        
        containerView.addSubview(inputTextField)
        containerView.addSubview(separatorLineView)
        containerView.addSubview(sendBtn)
        containerView.addSubview(sendTextBtn)
        
        NSLayoutConstraint.activate([
            //sendBtn
            sendBtn.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -10),
            sendBtn.centerYAnchor.constraint(equalTo: containerView.centerYAnchor),
            sendBtn.widthAnchor.constraint(equalToConstant: 50),
            sendBtn.heightAnchor.constraint(equalTo: containerView.heightAnchor),
            
            //sendTextBtn
            sendTextBtn.centerXAnchor.constraint(equalTo: sendBtn.centerXAnchor),
            sendTextBtn.centerYAnchor.constraint(equalTo: sendBtn.centerYAnchor),
       
            //nameTextField
            inputTextField.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 12),
            inputTextField.centerYAnchor.constraint(equalTo: containerView.centerYAnchor),
            inputTextField.trailingAnchor.constraint(equalTo: sendBtn.leadingAnchor),
            inputTextField.heightAnchor.constraint(equalTo: containerView.heightAnchor, constant: -2),

            //nameSeparatorView
            separatorLineView.leftAnchor.constraint(equalTo: containerView.leftAnchor),
            separatorLineView.topAnchor.constraint(equalTo: containerView.topAnchor),
            separatorLineView.widthAnchor.constraint(equalTo: containerView.widthAnchor),
            separatorLineView.heightAnchor.constraint(equalToConstant: 1.5)
            ])
        
    }
    
}
