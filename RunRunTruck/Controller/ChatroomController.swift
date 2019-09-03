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
    
    var chatRoomView = ChatRoomView(frame:
        CGRect(x: 0, y: 0,
               width: UIScreen.main.bounds.width,
               height: UIScreen.main.bounds.height))
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
       collectionView.backgroundColor = .white
        navigationItem.title = "Chatroom"
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage.asset(.Icon_back),
                                                           style: .plain,
                                                           target: self,
                                                           action: #selector(backToRoot))

        view.addSubview(chatRoomView)

    }

    @objc func backToRoot() {

        self.navigationController?.popViewController(animated: false)

    }
}
