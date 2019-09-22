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
    
    var cellForOther: String = "cellForOther"
    
    var cellForSelf: String = "cellForSelf"
    
    var cellForBlock: String = "cellForBlock"
    
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
        
        chatRoomView.msgCollectionView.register(ChatMessageCell.self, forCellWithReuseIdentifier: cellForOther)
        
        chatRoomView.msgCollectionView.register(ChatCellForSelf.self, forCellWithReuseIdentifier: cellForSelf)
        
        chatRoomView.msgCollectionView.register(BlockMessageCell.self, forCellWithReuseIdentifier: cellForBlock)
        
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
                    
                    let collectionView = weakSelf.chatRoomView.msgCollectionView
                    
                    let bottomOffsetY = collectionView.collectionViewLayout.collectionViewContentSize.height +
                        collectionView.contentInset.bottom -
                        collectionView.frame.size.height
                    let range = bottomOffsetY - weakSelf.chatRoomView.msgCollectionView.contentOffset.y
                    
                    if range <= 5 && range >= -5 {
                        weakSelf.isNeedToScrollToBottomWhenUpdated = true
                    } else {
                        weakSelf.isNeedToScrollToBottomWhenUpdated = false
                    }
                    
                    weakSelf.chatRoomView.msgCollectionView.reloadData()
                    weakSelf.checkIfNeedToScrollToBottom()
                }
                
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
        
        guard let text = chatRoomView.inputTextField.text else { return }
        
        if text.isEmpty == false {
            
            if let uid = FirebaseManager.shared.userID {
                
                creatChatMessage(id: uid, text: text)
                
            } else if let boosId = FirebaseManager.shared.bossID {
                
                creatChatMessage(id: boosId, text: text)
            }
            
            chatRoomView.inputTextField.text = ""
        }
        
    }
    
    func creatChatMessage(id: String, text: String) {
        
        var image: String?
        
        guard let truckID = truckData?.id,
            let name = FirebaseManager.shared.currentUser?.name
            else {
                print("uid nil")
                return
        }
        
        image = FirebaseManager.shared.currentUser?.logoImage
        
        FirebaseManager.shared.creatChatRoomOne(
            truckID: truckID,
            uid: id,
            name: name,
            image: image,
            text: text)
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
        
        let messageData = messages[indexPath.item]
        
        
        
        if messageData.uid == FirebaseManager.shared.userID || messageData.uid == FirebaseManager.shared.bossID {
            
            guard let chatCell = collectionView.dequeueReusableCell(
                withReuseIdentifier: cellForSelf,
                for: indexPath) as? ChatCellForSelf else { return UICollectionViewCell() }
            
            chatCell.setupCellValue(text: messageData.text, name: nil, image: nil)
            
            chatCell.bubbleHeightAnchor?.constant = estimateFrameForText(text: messageData.text).height + 8
            
            chatCell.delegate = self
            
            return chatCell
            
        } else {
            
             guard let chatCell = collectionView.dequeueReusableCell(
                withReuseIdentifier: cellForBlock,
                for: indexPath) as? BlockMessageCell else { return UICollectionViewCell() }
            
                 chatCell.setupCellValue(text: "你已封鎖此用戶訊息", name: nil, image: nil)
            
            chatCell.bubbleHeightAnchor?.constant = estimateFrameForText(text: messageData.text).height + 8
//            guard let chatCell = collectionView.dequeueReusableCell(
//                withReuseIdentifier: cellForOther,
//                for: indexPath) as? ChatMessageCell else { return UICollectionViewCell() }
//
//             chatCell.setupCellValue(
//                text: messageData.text,
//                name: messageData.name,
//                image: messageData.name == truckData?.name ? truckData?.logoImage : messageData.logoImage )
//
//            chatCell.bubbleHeightAnchor?.constant = estimateFrameForText(text: messageData.text).height + 8
//
//            chatCell.delegate = self
            
            return chatCell
        }
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

extension ChatroomViewController: ChatMessageCellDelegate {
    
    func passLongGesture(cell: UICollectionViewCell) {
        
        let collectionView = self.chatRoomView.msgCollectionView
        
        guard let indexPath = collectionView.indexPath(for: cell) else {
            return
        }
        
        guard messages[indexPath.item].name != truckData?.name else {
            //Todo
            print("封鎖老闆就看不到餐廳最新消息囉！")
            return
        }

        if FirebaseManager.shared.userID != nil {
            
            showBlockAlert(cell: cell, index: indexPath.item)
        }
    }
    
    func showBlockAlert(cell: UICollectionViewCell, index: Int) {
        
        let controller = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        let text = "封鎖此用戶"
        
        let action = UIAlertAction(title: text, style: .default) { (action) in
            
            FirebaseManager.shared.addUserBlock(
                uid: FirebaseManager.shared.userID!,
                blockId: self.messages[index].uid)
        }
        
        controller.addAction(action)
        
        let cancelAction = UIAlertAction(title: "取消", style: .cancel, handler: nil)
        controller.addAction(cancelAction)
        present(controller, animated: true, completion: nil)
    }
}

extension ChatroomViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        var height: CGFloat = 80
        
        let messageData = messages[indexPath.item]
        
        if messageData.uid == FirebaseManager.shared.userID {
            
            height = estimateFrameForText(text: messageData.text).height + 20
            
        } else {
            
            height = estimateFrameForText(text: messageData.text).height
                + estimateFrameForText(text: messageData.name).height + 20
        }
        return CGSize(width: chatRoomView.frame.width, height: height)
    }
    
    func estimateFrameForText(text: String) -> CGRect {
        let size = CGSize(width: 200, height: 1000)
        let options = NSStringDrawingOptions.usesFontLeading.union(.usesLineFragmentOrigin)
        let attributes = [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 16)]
        
        return NSString(string: text).boundingRect(with: size, options: options, attributes: attributes, context: nil)
    }
}
