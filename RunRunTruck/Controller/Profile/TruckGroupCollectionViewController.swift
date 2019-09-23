//
//  TruckGroupCollectionViewController.swift
//  RunRunTruck
//
//  Created by yueh on 2019/9/23.
//  Copyright © 2019 yueh. All rights reserved.
//

import UIKit

class TruckGroupCollectionViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    var trucks: [TruckShortInfo] = []
    init() {
        super.init(collectionViewLayout: UICollectionViewFlowLayout())
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.backgroundColor = .white
        collectionView.register(TruckCardCollectionViewCell.self, forCellWithReuseIdentifier: "cellId")
        
        if let layout = collectionViewLayout as? UICollectionViewFlowLayout {
            layout.scrollDirection = .horizontal
            layout.minimumInteritemSpacing = 8
        }
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return trucks.count
    }
    
    override func collectionView(_ collectionView: UICollectionView,
                                 cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let truckInfo = trucks[indexPath.row]
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: "cellId",
            for: indexPath) as? TruckCardCollectionViewCell else {
                let newCell = TruckCardCollectionViewCell()
                return newCell
        }
        cell.layer.cornerRadius = 5
        cell.clipsToBounds = true
        cell.setupCellWithTruckInfo(truckInfo)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        return .init(width: 100, height: view.frame.size.height - 16)
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        insetForSectionAt section: Int) -> UIEdgeInsets {
        return .init(top: 5, left: 8, bottom: 0, right: 8)
    }
}
