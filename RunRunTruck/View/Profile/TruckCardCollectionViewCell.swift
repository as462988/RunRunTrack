//
//  TruckCardCollectionViewCell.swift
//  RunRunTruck
//
//  Created by yueh on 2019/9/23.
//  Copyright © 2019 yueh. All rights reserved.
//

import UIKit

class TruckCardCollectionViewCell: UICollectionViewCell {
    let topImageView: UIImageView = {
        let image = UIImageView()
        image.layer.cornerRadius = 5
        image.clipsToBounds = true
        image.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        return image
    }()
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 15)
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .white

        addSubview(topImageView)
        addSubview(titleLabel)
        setupViews()
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        
        layer.shadowPath = UIBezierPath(roundedRect: self.bounds, cornerRadius: 5).cgPath
        layer.shadowOffset = CGSize(width: 2, height: 2)
        layer.shadowRadius = 2
        layer.shadowOpacity = 0.7
        layer.shadowColor = UIColor.black.cgColor
        layer.masksToBounds = false
    }
    
    func setupViews() {
        topImageView.anchor(top: topAnchor, leading: leadingAnchor, bottom: nil, trailing: trailingAnchor)
        topImageView.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 0.6).isActive = true
        titleLabel.anchor(top: topImageView.bottomAnchor,
                          leading: leadingAnchor, bottom: nil, trailing: nil,
                          padding: .init(top: 4, left: 4, bottom: 0, right: 0))
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupCellWithTruckInfo(_ truckInfo: TruckData) {
        topImageView.loadImage(truckInfo.logoImage)
        titleLabel.text = truckInfo.name
    }
}
