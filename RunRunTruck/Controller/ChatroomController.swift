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
    
    var message = [Message]()
    
    let text = "Example: Chat Text, Example: Chat Text, Example: Chat Texthdheuhuihiuhruiheiurhiuehriuheri"
    
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

         chatCell.textView.text = text
        
        chatCell.bubbleWidthAnchor?.constant = estimateFrameForText(text: self.text).width + 32
        
        return chatCell

    }
    
    // 旋轉時不會跑版
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        collectionView.collectionViewLayout.invalidateLayout()
    }
}

extension ChatroomController: UICollectionViewDelegateFlowLayout {

    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {

        var height: CGFloat = 80
        // 這邊要帶入收到的 message
        
//        if let text = message[indexPath.item].text {
//
            height = estimateFrameForText(text: self.text).height + 20
//        }
        
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
