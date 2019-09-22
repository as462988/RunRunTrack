//
//  BlockViewController.swift
//  RunRunTruck
//
//  Created by yueh on 2019/9/23.
//  Copyright © 2019 yueh. All rights reserved.
//

import UIKit

class BlockViewController: UIViewController {
    
    @IBOutlet weak var bgView: UIView!
    @IBOutlet weak var closeBtn: UIButton!
    @IBOutlet weak var blockTableiew: UITableView!
    
    var deleteId: String?
    var nameArr: [String] = []

    override func viewDidLoad() {
        super.viewDidLoad()

        blockTableiew.delegate = self
        blockTableiew.dataSource = self
        bgView.layer.cornerRadius = 10
        bgView.clipsToBounds = true
        closeBtn.addTarget(self, action: #selector(clickCloseBtn), for: .touchUpInside)
        getBlockUserName()
    }

    @objc func clickCloseBtn() {
        
        self.dismiss(animated: false, completion: nil)
    }
    
    func getBlockUserName() {
        
        if let block = FirebaseManager.shared.currentUser?.block {
            
            guard block.count != 0 else {
                return
            }
            
            for num in 0...block.count - 1 {
                
                FirebaseManager.shared.getBlockUserName(blockId: block[num]) { [weak self] (userName) in
                    
                    self?.nameArr.append(userName ?? "")
                    DispatchQueue.main.async {
                        self?.blockTableiew.reloadData()
                    }
                }
            }

        }

    }
}

extension BlockViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
           
           if let block = FirebaseManager.shared.currentUser?.block {
               return block.count
           }
           return 3
       }
       
       func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
           guard  let blockCell = tableView.dequeueReusableCell(
               withIdentifier: "blockCell", for: indexPath) as? BlockTableViewCell else {  return UITableViewCell() }
        blockCell.cancelBlockBtn.addTarget(self, action: #selector(clickCancelBlockBtn), for: .touchUpInside)
        blockCell.setValue(name: nameArr.count != 0 ? nameArr[indexPath.item] : "")
        blockCell.setLayout()
        self.deleteId = FirebaseManager.shared.currentUser?.block[indexPath.item]
           return blockCell
       }
    
    @objc func clickCancelBlockBtn() {

        guard let deleteId = self.deleteId else {
            return
        }
        
        FirebaseManager.shared.deleteUserBlock(uid: FirebaseManager.shared.userID!,
                                               blockId: deleteId) { [weak self] in
                                                self?.blockTableiew.reloadData()
        }
    }
}
