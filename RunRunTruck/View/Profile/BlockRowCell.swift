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
        label.font = .systemFont(ofSize: 18)
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
        nameLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 30).isActive = true
        nameLabel.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        addSubview(blockBtn)
        blockBtn.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        blockBtn.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20).isActive = true
        blockBtn.widthAnchor.constraint(equalToConstant: 60).isActive = true
        blockBtn.heightAnchor.constraint(equalToConstant: 30).isActive = true
        blockBtn.layer.cornerRadius = 15
        blockBtn.clipsToBounds = true
        let bottomLine = UIView()
        addSubview(bottomLine)
        bottomLine.backgroundColor = .lightGray
        bottomLine.translatesAutoresizingMaskIntoConstraints = false
        bottomLine.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 30).isActive = true
        bottomLine.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        bottomLine.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
        bottomLine.heightAnchor.constraint(equalToConstant: 0.5).isActive = true
    }
    
    func updateViewsWithBlockUser(blockUser: BlockUser) {
        self.blockUser = blockUser
        nameLabel.text = self.blockUser.userName
        blockBtn.addTarget(self, action: #selector(blockBtnDidTap), for: .touchUpInside)
    }
    
    @objc func blockBtnDidTap() {
        
        guard let uid = FirebaseManager.shared.currentUser?.uid else { return }

        FirebaseManager.shared.updateRemoveArrayData(
            type: User.user.rawValue,
            id: uid,
            key: User.block.rawValue,
            value: blockUser.userId) {[weak self] in
                self?.delegate?.blockRowCellDidSuccessBlockUser(lockRowCell: self!)
        }
    }
}
