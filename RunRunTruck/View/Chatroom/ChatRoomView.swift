//
//  ChatRoomView.swift
//  RunRunTruck
//
//  Created by yueh on 2019/9/4.
//  Copyright © 2019 yueh. All rights reserved.
//

import UIKit

class ChatRoomView: UIView {
    
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
        button.addTarget(self, action: #selector(handleSend), for: .touchUpInside)
        return button
    }()
    
    let sendTextBtn: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Send", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(handleSend), for: .touchUpInside)
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
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.addSubview(containerView)
        setupInputComponents()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func handleSend() {
        print("123")
    }
    
    func setupInputComponents() {
        
        //inputContainerView
        NSLayoutConstraint.activate([
            containerView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            containerView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            containerView.bottomAnchor.constraint(equalTo: self.safeAreaLayoutGuide.bottomAnchor),
            containerView.heightAnchor.constraint(equalToConstant: 60)
            ])
        
        containerView.addSubview(inputTextField)
        containerView.addSubview(separatorLineView)
        containerView.addSubview(sendBtn)
        containerView.addSubview(sendTextBtn)
        
        NSLayoutConstraint.activate([
            sendBtn.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -10),
            sendBtn.centerYAnchor.constraint(equalTo: containerView.centerYAnchor),
            sendBtn.widthAnchor.constraint(equalToConstant: 50),
            sendBtn.heightAnchor.constraint(equalTo: containerView.heightAnchor),
            sendTextBtn.centerXAnchor.constraint(equalTo: sendBtn.centerXAnchor),
            sendTextBtn.centerYAnchor.constraint(equalTo: sendBtn.centerYAnchor)
            ])
        
        //nameTextField
        NSLayoutConstraint.activate([
            inputTextField.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 12),
            inputTextField.centerYAnchor.constraint(equalTo: containerView.centerYAnchor),
            inputTextField.trailingAnchor.constraint(equalTo: sendBtn.leadingAnchor),
            inputTextField.heightAnchor.constraint(equalTo: containerView.heightAnchor, constant: -2)
            ])
        
        //nameSeparatorView
        NSLayoutConstraint.activate([
            separatorLineView.leftAnchor.constraint(equalTo: containerView.leftAnchor),
            separatorLineView.topAnchor.constraint(equalTo: containerView.topAnchor),
            separatorLineView.widthAnchor.constraint(equalTo: containerView.widthAnchor),
            separatorLineView.heightAnchor.constraint(equalToConstant: 1.5)
            ])
        
    }
}
