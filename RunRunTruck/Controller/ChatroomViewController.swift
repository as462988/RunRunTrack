//
//  ChatroomViewController.swift
//  RunRunTruck
//
//  Created by yueh on 2019/9/6.
//  Copyright © 2019 yueh. All rights reserved.
//

import UIKit

class ChatroomViewController: UIViewController {
    
    var chatRoomView = ChatRoomView()
    
    var cellId: String = "cellId"
    
    var truckData: TruckData?
    
    var messages: [Message] = []
    
    var isFirstLoad = true
    
    var isNeedToScrollToBottomWhenUpdated = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.addSubview(chatRoomView)
        
        setContainView()
        
        chatRoomView.delegate = self
        
        navigationItem.title = truckData?.name ?? "nil"
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage.asset(.Icon_back),
                                                           style: .plain,
                                                           target: self,
                                                           action: #selector(backToRoot))
        
        chatRoomView.msgCollectionView.register(ChatMessageCell.self, forCellWithReuseIdentifier: cellId)
        
        chatRoomView.sendBtn.addTarget(self, action: #selector(handleSend), for: .touchUpInside)
        
        chatRoomView.sendTextBtn.addTarget(self, action: #selector(handleSend), for: .touchUpInside)
        
        observerChatRoom()
    }
    
    func observerChatRoom() {
        guard let truckID = truckData?.id else {
            print("no turckID")
            return
        }
        
        FirebaseManager.shared.observeMessage(truckID: truckID) { [weak self] (messages) in
            self?.messages.append(contentsOf: messages)
            
            if let weakSelf = self {
                DispatchQueue.main.async {
                    let bottomOffsetY = weakSelf.chatRoomView.msgCollectionView.collectionViewLayout.collectionViewContentSize.height + weakSelf.chatRoomView.msgCollectionView.contentInset.bottom -
                        weakSelf.chatRoomView.msgCollectionView.frame.size.height
                    let range = bottomOffsetY - weakSelf.chatRoomView.msgCollectionView.contentOffset.y
                    
                    if range <= 5 && range >= -5 {
                        weakSelf.isNeedToScrollToBottomWhenUpdated = true
                    } else {
                        weakSelf.isNeedToScrollToBottomWhenUpdated = false
                    }

                    weakSelf.chatRoomView.msgCollectionView.reloadData()
                    weakSelf.checkIfNeedToScrollToBottom()
                }
                
//                DispatchQueue.main.asyncAfter(deadline: .now() + 0, execute: {
//                    weakSelf.checkIfNeedToScrollToBottom()
//                })
            }
        }
    }
    
    func checkIfNeedToScrollToBottom() {
        if messages.count > 0 && isFirstLoad {
            isFirstLoad = false
            self.chatRoomView.msgCollectionView.scrollToItem(
                at: .init(item: messages.count - 1, section: 0),
                at: .bottom,
                animated: false)
            return
        }
        if isNeedToScrollToBottomWhenUpdated {
            chatRoomView.msgCollectionView.scrollToItem(
                at: .init(item: messages.count - 1, section: 0),
                at: .bottom,
                animated: true)
        }
    }
    
    @objc func backToRoot() {
        
        isFirstLoad = true
        
        FirebaseManager.shared.message = []
        
        self.navigationController?.popViewController(animated: false)
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
    
    func setContainView() {
        chatRoomView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            chatRoomView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            chatRoomView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
            chatRoomView.topAnchor.constraint(equalTo: self.view.topAnchor),
            chatRoomView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor)
            ])
    }
}

extension ChatroomViewController: TruckChatroomViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return messages.count
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let chatCell = collectionView.dequeueReusableCell(
            withReuseIdentifier: cellId,
            for: indexPath) as? ChatMessageCell else { return UICollectionViewCell() }
        
        let messageData = messages[indexPath.item]
        
        chatCell.setupCellValue(text: messageData.text, name: messageData.name)
        chatCell.textViewHeightAnchor?.constant = estimateFrameForText(text: messageData.text).height
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
    
    func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        return false
    }
    
    // 旋轉時不會跑版
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        chatRoomView.msgCollectionView.collectionViewLayout.invalidateLayout()
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        handleSend()
        
        return true
    }
}
extension ChatroomViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        var height: CGFloat = 80
        
        let messageData = messages[indexPath.item]
        
        height = estimateFrameForText(text: messageData.text).height
            + estimateFrameForText(text: messageData.name).height + 20
        
        return CGSize(width: chatRoomView.frame.width, height: height)
    }
    
    func estimateFrameForText(text: String) -> CGRect {
        let size = CGSize(width: 200, height: 1000)
        let options = NSStringDrawingOptions.usesFontLeading.union(.usesLineFragmentOrigin)
        let attributes = [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 16)]
        
        return NSString(string: text).boundingRect(with: size, options: options, attributes: attributes, context: nil)
    }
}
