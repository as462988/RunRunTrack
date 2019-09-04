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
    
    var chatRoomView = ChatRoomView()
    
    var truckData: TruckData?
    
    let text = "If you are going to use a passage of Lorem Ipsum, you need to be sure there isn't anything embarrassing hidden in the middle of text"
    let text2 = "Lorem ipsum dolor sitr Lorem ipsum dolor sitr Lorem ipsum dolor sitr Lorem ipsum dolor sitr"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.contentInset = UIEdgeInsets(top: 8, left: 0, bottom: 70, right: 0)
        collectionView.alwaysBounceVertical = true
        collectionView.backgroundColor = .white
        
        navigationItem.title = "Chatroom"
        
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
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        FirebaseManager.shared.getTruckId(truckName: self.truckData?.name ?? "nil")
    }
    
    @objc func handleSend() {
        guard let uid = FirebaseManager.shared.userID, let name = FirebaseManager.shared.currentUser?.name else {
            return
        }
        
        if let text = chatRoomView.inputTextField.text {
            
            print(self.truckData?.name ?? "nil")
        
                FirebaseManager.shared.creatChatRoom(
                    truckName: self.truckData?.name ?? "nil",
                    uid: uid,
                    name: name,
                    text: text)
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
        
        self.navigationController?.popViewController(animated: false)
        
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 10
    }
    
    override func collectionView(_ collectionView: UICollectionView,
                                 cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let chatCell = collectionView.dequeueReusableCell(
            withReuseIdentifier: cellId,
            for: indexPath) as? ChatMessageCell else { return UICollectionViewCell() }
        
        // 呼叫 setupCell
        if indexPath.item % 3 == 1 {
            
            chatCell.textView.text = text
            chatCell.bubbleView.backgroundColor = ChatMessageCell.myMessageColor
            
            chatCell.nameTextLabel.isHidden = true
            chatCell.profileImageView.isHidden = true
            chatCell.bubbleViewTopAnchor?.isActive = true
            chatCell.bubbleViewTopAnchorWithName?.isActive = false
            chatCell.bubbleTrailingAnchor?.isActive = true
            chatCell.bubbleLeadingAnchor?.isActive = false
            chatCell.bubbleViewHeightAnchor?.isActive = true
            chatCell.bubbleViewheigHtAnchorWithName?.isActive = false
        } else {
            
            chatCell.textView.text = text2
            chatCell.bubbleView.backgroundColor = UIColor(r: 240, g: 240, b: 240)
            chatCell.textView.textColor = .black
            
            chatCell.bubbleTrailingAnchor?.isActive = false
            chatCell.bubbleLeadingAnchor?.isActive = true
            chatCell.profileImageView.isHidden = false
            chatCell.nameTextLabel.isHidden = false
            chatCell.bubbleViewTopAnchor?.isActive = false
            chatCell.bubbleViewTopAnchorWithName?.isActive = true
            
            chatCell.bubbleViewHeightAnchor?.isActive = false
            chatCell.bubbleViewheigHtAnchorWithName?.isActive = true
            
        }
        
        chatCell.bubbleWidthAnchor?.constant = estimateFrameForText(text: self.text).width + 32
        
        return chatCell
        
    }
    //test -> message: Message
    private func setupCell(cell: ChatMessageCell, test: String) {
        //如果 uid ==  自己的id 執行
        //        if indexPath.item % 3 == 1 {
        //
        //            chatCell.textView.text = text
        //            chatCell.bubbleView.backgroundColor = ChatMessageCell.myMessageColor
        //
        //        } else {
        //
        //            chatCell.textView.text = text2
        //            chatCell.bubbleView.backgroundColor = .lightGray
        //        }
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
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        var height: CGFloat = 80
        // 這邊要帶入收到的 message
        
        //        if let text = message[indexPath.item].text {
        //
        //            height = estimateFrameForText(text: self.text).height + 20
        //        }
        
        if indexPath.item % 3 == 1 {
            
            height = estimateFrameForText(text: self.text).height + 20
        } else {
            
            height = estimateFrameForText(text: self.text2).height + 70
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
