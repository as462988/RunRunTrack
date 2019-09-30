//
//  TruckViewController.swift
//  RunRunTruck
//
//  Created by yueh on 2019/9/19.
//  Copyright © 2019 yueh. All rights reserved.
//

import UIKit
import Lottie

class TruckViewController: UIViewController {
    
    @IBOutlet weak var truckCollectionView: UICollectionView! {
        didSet {
            truckCollectionView.delegate = self
            truckCollectionView.dataSource = self
        }
    }
    
    var allTruckArr = [TruckData]()
    var openTruckArr = [TruckData]()
    var disOpenTruckArr = [TruckData]()
    
    let addressManager = AddressManager()
    let dispatchGroup = DispatchGroup()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        handlerOpeningTruck()
        handlerDisOpeningTruck()
        truckCollectionView.showsVerticalScrollIndicator = false
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        self.navigationController?.isNavigationBarHidden = false
    }
    
    func handlerOpeningTruck() {
        FirebaseManager.shared.getOpeningTruckData(isOpen: true) {[weak self] (truckDatas) in
            if let truckDatas = truckDatas {

                for var truckData in truckDatas {

                    switch truckData.1 {
                    case .added:
                        //新增
                        self?.addressManager.getLocationAddress(
                            lat: truckData.0.location!.latitude,
                            long: truckData.0.location!.longitude,
                            completion: {(location, error) in

                                guard let location = location else {return}

                                let address = location.subAdministrativeArea
                                    + location.city + location.street

                                truckData.0.address = address
                                self?.openTruckArr.append(truckData.0)

                                DispatchQueue.main.async {
                                    self?.truckCollectionView.reloadData()
                                }
                        })

                    case .removed:
                        //刪除

                        if let index = self?.openTruckArr.firstIndex(
                            where: { (truckdata) -> Bool in
                                return truckdata.id == truckData.0.id
                        }) {
                            self?.openTruckArr.remove(at: index)
                        }
                    case .modified: break
                    @unknown default:
                        fatalError()
                    }
                }

            }
        }
    }
    
    func handlerDisOpeningTruck() {
       FirebaseManager.shared.getOpeningTruckData(isOpen: false) {[weak self] (truckDatas) in
           if let truckDatas = truckDatas {
               
               for var truckData in truckDatas {
                   
                   switch truckData.1 {
                   case .added:
                       //新增
                       if let location = truckData.0.location {
                       self?.addressManager.getLocationAddress(
                           lat: location.latitude,
                           long: location.longitude,
                           completion: {(location, error) in
                               
                               guard let location = location else {return}
                               
                               let address = location.subAdministrativeArea
                                   + location.city + location.street
                               
                               truckData.0.address = address
                               self?.disOpenTruckArr.append(truckData.0)
                            
                            DispatchQueue.main.async {
                                self?.truckCollectionView.reloadData()
                            }
                       })
                       
                       } else {
                        self?.disOpenTruckArr.append(truckData.0)
                        
                        DispatchQueue.main.async {
                            self?.truckCollectionView.reloadData()
                        }
                    }
                    
                   case .removed:
                       //刪除
                       
                       if let index = self?.disOpenTruckArr.firstIndex(
                           where: { (truckdata) -> Bool in
                               return truckdata.id == truckData.0.id
                       }) {
                           self?.disOpenTruckArr.remove(at: index)
                       }
                   case .modified: break
                   @unknown default:
                       fatalError()
                   }
               }
               
           }
       }
    }
    func handGester(view: AnimationView) {
        
        view.animation = Animation.named(Lottie.openTruck.rawValue)
        view.loopMode = .loop
        view.play()
    }
}

extension TruckViewController:
UICollectionViewDelegate,
UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return openTruckArr.count + disOpenTruckArr.count
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let truckCell = collectionView.dequeueReusableCell(
            withReuseIdentifier: "truckCell",
            for: indexPath) as? TrcukCollectionViewCell else {
                return UICollectionViewCell()
        }
        
        allTruckArr = openTruckArr + disOpenTruckArr
        
        truckCell.setValue(name: allTruckArr[indexPath.item].name,
                           logoImage: allTruckArr[indexPath.item].logoImage,
                           image: allTruckArr[indexPath.item].detailImage ?? "")
        
        if allTruckArr[indexPath.item].open {
            
            truckCell.animationView.isHidden = false

            handGester(view: truckCell.animationView)
        } else {
            truckCell.animationView.isHidden = true

        }

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
