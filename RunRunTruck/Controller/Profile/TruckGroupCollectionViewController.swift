//
//  TruckGroupCollectionViewController.swift
//  RunRunTruck
//
//  Created by yueh on 2019/9/23.
//  Copyright © 2019 yueh. All rights reserved.
//

import UIKit

class TruckGroupCollectionViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    var trucks: [TruckData] = []
    let addressManager = AddressManager()
    
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
        collectionView.showsHorizontalScrollIndicator = false
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
    
    override func collectionView(_ collectionView: UICollectionView,
                                 didSelectItemAt indexPath: IndexPath) {
         guard let truckVC = UIStoryboard.truck.instantiateViewController(
                    withIdentifier: "truckInfoVC") as? TruckDetailViewController else {return}
        
        guard let location = trucks[indexPath.item].location else {return}
        addressManager.getLocationAddress(
            lat: location.latitude,
            long: location.longitude) {[weak self] (location, error) in
                                             guard let location = location else {return}
                let address = location.subAdministrativeArea
                                                  + location.city + location.street
                self?.trucks[indexPath.item].address = address
                truckVC.detailInfo = self?.trucks[indexPath.item]
                
                DispatchQueue.main.async {
                    guard let rootVC = AppDelegate.shared.window?.rootViewController
                        as? TabBarViewController,
                        let nc = rootVC.viewControllers?[3] as? NavigationController else { return }
                    nc.pushViewController(truckVC, animated: true)
                }
        }
        
////        truckVC.detailInfo = trucks[indexPath.item]
//        //tricky way
//        guard let rootVC = AppDelegate.shared.window?.rootViewController
//            as? TabBarViewController, let nc = rootVC.viewControllers?[3] as? NavigationController else { return }
//        nc.pushViewController(truckVC, animated: true)
    }
}
