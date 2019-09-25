//
//  BlockRowCell.swift
//  RunRunTruck
//
//  Created by yueh on 2019/9/24.
//  Copyright © 2019 yueh. All rights reserved.
//

import UIKit

protocol BlockRowCellDelegate: class {
    func blockRowCellDidSuccessBlockUser(lockRowCell: BlockRowCell)
}

class BlockRowCell: UITableViewCell {
    var nameLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 24)
        label.textColor = .darkGray
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    var blockBtn: UIButton = {
       let button = UIButton(type: .system)
        button.setTitle("解除", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.textColor = .white
        button.backgroundColor = .darkGray
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    weak var delegate: BlockRowCellDelegate?
    var blockUser: BlockUser!
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectionStyle = .none
        setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupViews() {
        addSubview(nameLabel)
        nameLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20).isActive = true
        nameLabel.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        addSubview(blockBtn)
        blockBtn.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        blockBtn.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20).isActive = true
        blockBtn.widthAnchor.constraint(equalToConstant: 60).isActive = true
        blockBtn.heightAnchor.constraint(equalToConstant: 30).isActive = true
        blockBtn.layer.cornerRadius = 15
        blockBtn.clipsToBounds = true
    }
    
    func updateViewsWithBlockUser(blockUser: BlockUser) {
        self.blockUser = blockUser
        nameLabel.text = self.blockUser.userNmae
        blockBtn.addTarget(self, action: #selector(blockBtnDidTap), for: .touchUpInside)
    }
    
    @objc func blockBtnDidTap() {
        FirebaseManager.shared.deleteUserBlock(uid: FirebaseManager.shared.userID!, blockId: blockUser.userId) {
            self.delegate?.blockRowCellDidSuccessBlockUser(lockRowCell: self)
        }
    }
}
