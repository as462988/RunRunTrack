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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.alwaysBounceVertical = true
        collectionView.backgroundColor = .white
        navigationItem.title = "Chatroom"
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage.asset(.Icon_back),
                                                           style: .plain,
                                                           target: self,
                                                           action: #selector(backToRoot))

        view.addSubview(chatRoomView)
        setChatRoomViewLayout()
        collectionView.register(ChatMessageCell.self, forCellWithReuseIdentifier: cellId)
 
    }
    
    func setChatRoomViewLayout(){
        chatRoomView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            chatRoomView.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor),
            chatRoomView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            chatRoomView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
            chatRoomView.heightAnchor.constraint(equalTo: chatRoomView.containerView.heightAnchor)
            ])
    }

    @objc func backToRoot() {

        self.navigationController?.popViewController(animated: false)

    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 5
    }

    override func collectionView(_ collectionView: UICollectionView,
                                 cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

      guard let chatCell = collectionView.dequeueReusableCell(
            withReuseIdentifier: cellId,
            for: indexPath) as? ChatMessageCell else { return UICollectionViewCell() }

        return chatCell

    }
}

extension ChatroomController: UICollectionViewDelegateFlowLayout {

    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {

        return CGSize(width: chatRoomView.frame.width, height: 80)
    }
}
