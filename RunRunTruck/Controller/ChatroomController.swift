//
//  ChatroomController.swift
//  RunRunTruck
//
//  Created by yueh on 2019/9/4.
//  Copyright © 2019 yueh. All rights reserved.
//

import Foundation
import UIKit

class ChatroomController: UICollectionViewController {
    
    let cellId = "chatroomCell"
    
    var chatRoomView = ChatRoomView() {
        didSet {
            chatRoomView.delegate = self
        }
    }
    var truckData: TruckData?
    var messages: [Message] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.contentInset = UIEdgeInsets(top: 8, left: 0, bottom: 70, right: 0)
        collectionView.alwaysBounceVertical = true
        
        collectionView.backgroundColor = .white
        
        navigationItem.title = truckData?.name ?? "nil"
        
        chatRoomView.backgroundColor = .white
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage.asset(.Icon_back),
                                                           style: .plain,
                                                           target: self,
                                                           action: #selector(backToRoot))
        
        view.addSubview(chatRoomView)
        setChatRoomViewLayout()
        collectionView.register(ChatMessageCell.self, forCellWithReuseIdentifier: cellId)
        
        chatRoomView.sendBtn.addTarget(self, action: #selector(handleSend), for: .touchUpInside)
        
        chatRoomView.sendTextBtn.addTarget(self, action: #selector(handleSend), for: .touchUpInside)

//        getMessagesBeenSent()
        observerChatRoom()
    }
    
    func getMessagesBeenSent() {
        if let id = truckData?.id {
            FirebaseManager.shared.getMessage(truckID: id) { (messages) in
                if let messages = messages {
                    self.messages.append(contentsOf: messages) 
                    DispatchQueue.main.async {
                        self.collectionView.reloadData()
                        //監聽聊天室
                        self.observerChatRoom()
                    }
                }
            }
        }
    }
    
    func observerChatRoom() {
        guard let truckID = truckData?.id else {
            print("no turckID")
            return
        }
        FirebaseManager.shared.observeMessage(truckID: truckID) { (messages) in
            self.messages.append(contentsOf: messages)
            DispatchQueue.main.async {
//                let bottomOffset = CGPoint(x: 0,
//                                           y:  self.collectionView.contentSize.height - self.collectionView.frame.size.height + self.collectionView.contentInset.bottom)
//                let isNeedToScrollToBottom = self.collectionView.contentOffset.y == bottomOffset.y
                
                self.collectionView.reloadData()
//                if isNeedToScrollToBottom {
//
//                    self.collectionView.scrollToItem(
//                        at: .init(row: self.messages.count - 1, section: 0),
//                        at: .bottom, animated: true)
//
//                }
            }
        }
    }
    
    @objc func handleSend() {

        guard let truckID = truckData?.id,
            let uid = FirebaseManager.shared.userID,
            let name = FirebaseManager.shared.currentUser?.name,
            let text = chatRoomView.inputTextField.text else {
            print("uid nil")
            return
        }
        
        if text != "" {
            
            print(self.truckData?.name ?? "nil")
        
            FirebaseManager.shared.creatChatRoom(
                truckID: truckID,
                truckName: self.truckData?.name ?? "nil",
                uid: uid,
                name: name,
                text: text)
            chatRoomView.inputTextField.text = ""
        }

    }
    
    func setChatRoomViewLayout() {
        chatRoomView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            chatRoomView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor),
            chatRoomView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            chatRoomView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
            chatRoomView.heightAnchor.constraint(equalTo: chatRoomView.containerView.heightAnchor)
            ])
    }
    
    @objc func backToRoot() {
        
        FirebaseManager.shared.message = []
        self.navigationController?.popViewController(animated: false)
        
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {

        return messages.count
    }
    
    override func collectionView(_ collectionView: UICollectionView,
                                 cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let chatCell = collectionView.dequeueReusableCell(
            withReuseIdentifier: cellId,
            for: indexPath) as? ChatMessageCell else { return UICollectionViewCell() }
        
        let messageData = messages[indexPath.item]
        
          chatCell.setupCellValue(text: messageData.text, name: messageData.name)
        
        self.setupCell(cell: chatCell, indexPath: indexPath)
        
        chatCell.bubbleWidthAnchor?.constant = estimateFrameForText(text: messageData.text).width + 32
        
        return chatCell
        
    }

    private func setupCell(cell: ChatMessageCell, indexPath: IndexPath) {

        let messageData = messages[indexPath.item]
        if messageData.uid == FirebaseManager.shared.userID {
            
            cell.textView.text = messageData.text
            cell.textView.textColor = .white
            cell.bubbleView.backgroundColor = ChatMessageCell.myMessageColor
            
            cell.nameTextLabel.isHidden = true
            cell.profileImageView.isHidden = true
            cell.bubbleViewTopAnchor?.isActive = true
            cell.bubbleViewTopAnchorWithName?.isActive = false
            cell.bubbleTrailingAnchor?.isActive = true
            cell.bubbleLeadingAnchor?.isActive = false
            cell.bubbleViewHeightAnchor?.isActive = true
            cell.bubbleViewheigHtAnchorWithName?.isActive = false
        } else {
            
            cell.textView.text = messageData.text
            cell.bubbleView.backgroundColor = UIColor(r: 240, g: 240, b: 240)
            cell.textView.textColor = .black
            cell.bubbleTrailingAnchor?.isActive = false
            cell.bubbleLeadingAnchor?.isActive = true
            cell.profileImageView.isHidden = false
            cell.nameTextLabel.isHidden = false
            cell.bubbleViewTopAnchor?.isActive = false
            cell.bubbleViewTopAnchorWithName?.isActive = true
            cell.bubbleViewHeightAnchor?.isActive = false
            cell.bubbleViewheigHtAnchorWithName?.isActive = true
            
        }
    }
    
    // 旋轉時不會跑版
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        collectionView.collectionViewLayout.invalidateLayout()
    }
    
    override func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        return false
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print(indexPath.item)
    }
}

extension ChatroomController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 5
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        var height: CGFloat = 80

        let messageData = messages[indexPath.item]
        if messageData.uid == FirebaseManager.shared.userID {
           
            height = estimateFrameForText(text: messageData.text).height + 20
        
        } else {

            height = estimateFrameForText(text: messageData.text).height + 70
        }
        
        return CGSize(width: chatRoomView.frame.width, height: height)
    }
    
    // 計算訊息的高度
    func estimateFrameForText(text: String) -> CGRect {
        let size = CGSize(width: 200, height: 1000)
        let options = NSStringDrawingOptions.usesFontLeading.union(.usesLineFragmentOrigin)
        let attributes = [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 16)]
        
        return NSString(string: text).boundingRect(with: size, options: options, attributes: attributes, context: nil)
    }
}

extension ChatroomController: ChatRoomViewDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        handleSend()
        
        return true
    }
    
}
