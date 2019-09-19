//
//  TruckViewController.swift
//  RunRunTruck
//
//  Created by yueh on 2019/9/19.
//  Copyright © 2019 yueh. All rights reserved.
//

import UIKit

class TruckViewController: UIViewController {
    
    @IBOutlet weak var truckCollectionView: UICollectionView! {
        didSet {
            truckCollectionView.delegate = self
            truckCollectionView.dataSource = self
        }
    }
    
    var allTruckArr = [TruckData]()
    let addressManager = AddressManager()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        FirebaseManager.shared.getAllTruckData { [weak self] (data) in
            guard let truckDatas = data else {return}
            
            for truckData in truckDatas {
                
                self?.allTruckArr.append(truckData)
                
            }

            
            DispatchQueue.main.async {
                self?.truckCollectionView.reloadData()
            }
        }
    }
    
    func transAddress(index: Int){
        
        guard let truckLocation = allTruckArr[index].location else {
            return
        }
        
        addressManager.getLocationAddress(lat: truckLocation.latitude,
                                          long: truckLocation.longitude) { [weak self] (location, error) in
                                           
                                            guard let location = location else {return}
                                            
                                            let address = location.subAdministrativeArea
                                                + location.city + location.street
                                            
                                            self?.allTruckArr[index].address = address
                                            
        }
    }
    
}

extension TruckViewController:
UICollectionViewDelegate,
UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return allTruckArr.count
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let truckCell = collectionView.dequeueReusableCell(
            withReuseIdentifier: "truckCell",
            for: indexPath) as? TrcukCollectionViewCell else {
                return UICollectionViewCell()
        }
        
        transAddress(index: indexPath.item)
        truckCell.setValue(name: allTruckArr[indexPath.item].name,
                           image: allTruckArr[indexPath.item].logoImage)
        truckCell.backgroundColor = .yellow
        
        return truckCell
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let itemSize = CGSize(
            width: UIScreen.main.bounds.width - 32,
            height: UIScreen.main.bounds.height / 6 - 10)
        
        return itemSize
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.hidesBottomBarWhenPushed = true
        
        guard let truckVC = UIStoryboard.truck.instantiateViewController(
            withIdentifier: "truckInfoVC") as? TruckDetailViewController else {return}
            
        truckVC.detailInfo = allTruckArr[indexPath.item]
        
        navigationController?.isNavigationBarHidden = true
        navigationController?.pushViewController(truckVC, animated: true)
        self.hidesBottomBarWhenPushed = false
    }
    
}
