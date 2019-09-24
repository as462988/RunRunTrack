//
//  BlockListViewController.swift
//  RunRunTruck
//
//  Created by yueh on 2019/9/24.
//  Copyright © 2019 yueh. All rights reserved.
//

import UIKit
private let cellId = "cellId"

typealias BlockUser = (userNmae: String, userId: String)

class BlockListViewController: UIViewController {
    var tableView: UITableView!
    var blockUsers: [BlockUser] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        tableView.register(BlockRowCell.self, forCellReuseIdentifier: cellId)
        reload()

    }
    
    @objc func reload() {
        let dispatchGroup = DispatchGroup()
        FirebaseManager.shared.currentUser?.block.forEach({ blockUserId in
            dispatchGroup.enter()
            FirebaseManager.shared.getBlockUserName(blockId: blockUserId, completion: { (name) in
                if let name = name {
                    self.blockUsers.append((name, blockUserId))
                    dispatchGroup.leave()
                }
            })
        })
        dispatchGroup.notify(queue: .main) {
            self.tableView.reloadData()
        }
    }
    
    func setupViews() {
        tableView = UITableView()
        tableView.delegate = self
        tableView.dataSource = self
        view.addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true
        tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
    }
    
}

extension BlockListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let blockUser = blockUsers[indexPath.row]
        var cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as? BlockRowCell
        if cell == nil {
            cell = BlockRowCell(style: .default, reuseIdentifier: cellId)
        }
        cell?.delegate = self
        cell!.updateViewsWithBlockUser(blockUser: blockUser)
        return cell!
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return blockUsers.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
}

extension BlockListViewController: UITableViewDelegate {
    
}

extension BlockListViewController: BlockRowCellDelegate {
    func blockRowCellDidSuccessBlockUser(lockRowCell: BlockRowCell) {
        if let index = blockUsers.firstIndex(where: { (blockUser) -> Bool in
            return blockUser.userId == lockRowCell.blockUser.userId
        }) {
            blockUsers.remove(at: index)
            tableView.reloadData()
        }
    }
}
