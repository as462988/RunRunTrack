//
//  TruckCardsCollectionViewController.swift
//  RunRunTruck
//
//  Created by yueh on 2019/9/23.
//  Copyright © 2019 yueh. All rights reserved.
//

import UIKit

private let reuseIdentifier = "Cell"

class ProfileContentCollectionViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    
    init() {
        super.init(collectionViewLayout: UICollectionViewFlowLayout())
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    var favoriteTrucks: [TruckData] = []
    var exploreTrucks: [TruckData] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.backgroundColor = .white
        if let layout = collectionViewLayout as? UICollectionViewFlowLayout {
            layout.scrollDirection = .vertical
            layout.minimumLineSpacing = 0
            layout.minimumInteritemSpacing = 0
        }
        collectionView.register(TrucksCardGroupCell.self, forCellWithReuseIdentifier: "favoriteCell")
        collectionView.register(TrucksCardGroupCell.self, forCellWithReuseIdentifier: "exploreCell")
        collectionView.register(MoreSettingCollectionViewCell.self, forCellWithReuseIdentifier: "settingCell")
        updateDataFromFirebaseManager()
        observerAllTruckData()
    }
    
    func updateDataFromFirebaseManager() {
        //先跟FirebaseManager拿所有的TruckData
        var copyAllTruckData = FirebaseManager.shared.allTruckData
        if let user = FirebaseManager.shared.currentUser {
            user.favorite.forEach { favoriteId in
                if let index = copyAllTruckData.firstIndex(where: { (truck) -> Bool in
                    truck.id == favoriteId
                }) {
                    favoriteTrucks.append(copyAllTruckData.remove(at: index))
                }
            }
            exploreTrucks = copyAllTruckData
            DispatchQueue.main.async {
                self.collectionView.reloadData()
            }
        }
    }
    
    func observerAllTruckData() {
        NotificationCenter.default.addObserver(self, selector: #selector(handleAllTruckDataUpdated), name: Notification.Name(FirebaseManager.allTruckDataNotificationName), object: nil)
    }
    
    @objc func handleAllTruckDataUpdated() {
        favoriteTrucks = []
        exploreTrucks = []
        updateDataFromFirebaseManager()
    }
    
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        //收藏餐車, 繼續探索, 更多設定
        return 2
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        switch indexPath.item {
        //收藏餐車, 繼續探索欄高
        case 0, 1:
            return .init(width: self.view.frame.size.width, height: 180)
        //更多設定欄高
        case 2:
            return .init(width: self.view.frame.size.width, height: 100)
        default:
            return .zero
        }
    }
    
    override func collectionView(_ collectionView: UICollectionView,
                                 cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch indexPath.item {
        case 0:
            //傳入探索的餐車
//            let exploreTrucks = exploreTruck
            guard let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: "exploreCell",
                for: indexPath) as? TrucksCardGroupCell else {
                let newCell = TrucksCardGroupCell()
                return newCell
            }
            cell.titleLabel.text = "探索餐車"
            cell.truckGroupCollectionViewController.trucks = exploreTrucks
            cell.truckGroupCollectionViewController.collectionView.reloadData()
            return cell
        case 1:
            //傳入已收藏的餐車
//            let favoriteTrucks = favoriteTruck
            guard let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: "favoriteCell",
                for: indexPath) as? TrucksCardGroupCell else {
                let newCell = TrucksCardGroupCell()
                return newCell
            }
            cell.titleLabel.text = "已收藏的餐車"
            cell.truckGroupCollectionViewController.trucks = favoriteTrucks
            cell.truckGroupCollectionViewController.collectionView.reloadData()
            return cell
        case 2:
            guard let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: "settingCell",
                for: indexPath) as? MoreSettingCollectionViewCell else {
                let newCell = MoreSettingCollectionViewCell()
                return newCell
            }
            return cell
        default:
            return UICollectionViewCell()
        }

    }
}
