//
//  ChatroomViewController.swift
//  RunRunTruck
//
//  Created by yueh on 2019/9/6.
//  Copyright © 2019 yueh. All rights reserved.
//

import UIKit

class ChatroomViewController: UIViewController {
    
    var containView = TruckChatroomView(frame: CGRect(x: 0,
                                                      y: 0,
                                                      width: UIScreen.main.bounds.width,
                                                      height: UIScreen.main.bounds.height))
    var cellId: String = "cellId"
    
    var truckData: TruckData?
    var messages: [Message] = []

    override func viewDidLoad() {
        super.viewDidLoad()
                
        self.view.addSubview(containView)
        
        setContainView()
        
        containView.delegate = self
        
        navigationItem.title = truckData?.name ?? "nil"
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage.asset(.Icon_back),
                                                           style: .plain,
                                                           target: self,
                                                           action: #selector(backToRoot))
        
        containView.msgCollectionView.register(ChatMessageCell.self, forCellWithReuseIdentifier: cellId)
        
        containView.sendBtn.addTarget(self, action: #selector(handleSend), for: .touchUpInside)
        
        containView.sendTextBtn.addTarget(self, action: #selector(handleSend), for: .touchUpInside)
        
        observerChatRoom()
    }
    
    func observerChatRoom() {
        guard let truckID = truckData?.id else {
            print("no turckID")
            return
        }
        
        let roomCollectionView = self.containView.msgCollectionView
        
        FirebaseManager.shared.observeMessage(truckID: truckID) { [weak self] (messages) in
            self?.messages.append(contentsOf: messages)
            DispatchQueue.main.async {
                let bottomOffset = roomCollectionView.contentSize.height - roomCollectionView.frame.size.height + roomCollectionView.contentInset.bottom
                
                let isNeedToScrollToBottom = roomCollectionView.contentOffset.y == bottomOffset
                
                roomCollectionView.reloadData()
                
                if isNeedToScrollToBottom {

                    roomCollectionView.setContentOffset(CGPoint(x: 0, y: bottomOffset), animated: true)
                }

            }
        }
    }
    
    @objc func backToRoot() {
        
        FirebaseManager.shared.message = []
        
        self.navigationController?.popViewController(animated: false)
    }
    
    @objc func handleSend() {
        
        guard let truckID = truckData?.id,
            let uid = FirebaseManager.shared.userID,
            let name = FirebaseManager.shared.currentUser?.name,
            let text = containView.inputTextField.text else {
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
            containView.inputTextField.text = ""
        }
        
    }
    
    func setContainView(){
        containView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            containView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            containView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
            containView.topAnchor.constraint(equalTo: self.view.topAnchor),
            containView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor)
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
    
    func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        return false
    }

    // 旋轉時不會跑版
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        containView.msgCollectionView.collectionViewLayout.invalidateLayout()
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
        if messageData.uid == FirebaseManager.shared.userID {
            
            height = estimateFrameForText(text: messageData.text).height + 20
            
        } else {
            height = estimateFrameForText(text: messageData.text).height + 70
        }
        
        return CGSize(width: containView.frame.width, height: height)
    }
    
    func estimateFrameForText(text: String) -> CGRect {
        let size = CGSize(width: 200, height: 1000)
        let options = NSStringDrawingOptions.usesFontLeading.union(.usesLineFragmentOrigin)
        let attributes = [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 16)]
        
        return NSString(string: text).boundingRect(with: size, options: options, attributes: attributes, context: nil)
    }
}
