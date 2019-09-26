//
//  TrucksCardGroupCell.swift
//  RunRunTruck
//
//  Created by yueh on 2019/9/23.
//  Copyright © 2019 yueh. All rights reserved.
//

import UIKit

class TrucksCardGroupCell: UICollectionViewCell {
    let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 24)
        return label
    }()
    let truckGroupCollectionViewController: TruckGroupCollectionViewController = TruckGroupCollectionViewController()
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .white
        addSubview(titleLabel)
        addSubview(truckGroupCollectionViewController.view)
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupViews() {
        titleLabel.anchor(
            top: topAnchor,
            leading: leadingAnchor,
            bottom: nil,
            trailing: trailingAnchor,
            padding: .init(top: 0, left: 8, bottom: 0, right: 0))
        truckGroupCollectionViewController.view.anchor(
            top: titleLabel.bottomAnchor,
            leading: leadingAnchor,
            bottom: bottomAnchor,
            trailing: trailingAnchor)
    }
}
