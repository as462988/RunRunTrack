//
//  ViewController.swift
//  RunRunTruck
//
//  Created by yueh on 2019/8/27.
//  Copyright © 2019 yueh. All rights reserved.
//

import UIKit
import GoogleMaps
import CoreLocation

class LobbyViewController: UIViewController {
    
    @IBOutlet weak var lobbyView: LobbyView! {
        
        didSet {
            
            lobbyView.delegate = self
        }
    }
    
    var index: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.isNavigationBarHidden = true
        //監聽collectionView contentOffset 變動
        FirebaseManager.shared.getTruckData { (data) in
            for (index, dataInfo) in FirebaseManager.shared.truckData.enumerated() {
                self.lobbyView.marker(lat: dataInfo.location.latitude,
                                      long: dataInfo.location.longitude)
                
                self.lobbyView.getLocation(lat: dataInfo.location.latitude,
                                           long: dataInfo.location.longitude,
                                           completion: { [weak self](location, error) in
                                            
                                            guard let location = location else {return}
                                            
                                            let address = location.subAdministrativeArea
                                                + location.city + location.street
                                            
                                            FirebaseManager.shared.truckData[index].address = address
                                            
                                            DispatchQueue.main.async {
                                                self?.lobbyView.reloadData()
                                            }
                })
            }
        }
    }
    
}

extension LobbyViewController: LobbyViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return FirebaseManager.shared.truckData.count
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: "truckInfoCell", for: indexPath) as? TurckInfoCollectionViewCell else {
                return UICollectionViewCell()
        }
        
        let data = FirebaseManager.shared.truckData[indexPath.row]
        
        let openTime = FirebaseManager.dateConvertString(
            date: data.openTime.dateValue())
        
        let colseTime = FirebaseManager.dateConvertString(
            date: data.closeTime.dateValue())
        
        cell.setValue(name: data.name,
                      openTime: openTime,
                      closeTime: colseTime,
                      logoImage: data.logoImage)
        cell.showTruckLocation(data.address)
        cell.latitude = data.location.latitude
        cell.longitude = data.location.longitude
        
        return cell
    }
    
//    func collectionView(_ collectionView: UICollectionView,
//                        willDisplay cell: UICollectionViewCell,
//                        forItemAt indexPath: IndexPath) {
//
//        let  cellCenter = cell.center.x - cell.bounds.width * CGFloat(indexPath.row) - 10.0 * CGFloat(indexPath.row)
//
//        print(indexPath.row)
//
//        print(Int(cellCenter) )
//
//        print(Int(UIScreen.main.bounds.width / 2))
//
//        guard Int(UIScreen.main.bounds.width / 2) == Int(cellCenter) else {return}
//
//        if indexPath.row != 0 {
//
//            lobbyView.updataMapView(lat: FirebaseManager.shared.truckData[indexPath.row-1].location.latitude,
//                                    long: FirebaseManager.shared.truckData[indexPath.row-1].location.longitude)
//        }
////
////        lobbyView.updataMapView(lat: FirebaseManager.shared.truckData[indexPath.row].location.latitude,
////                                long: FirebaseManager.shared.truckData[indexPath.row].location.longitude)
//    }
    
    func mapView(_ mapView: GMSMapView, didTap marker: GMSMarker) -> Bool {
        
        var indexNum = Int()
        
        for (index, data) in FirebaseManager.shared.truckData.enumerated() where

            marker.position.latitude == data.location.latitude {

                indexNum = index
        }

        self.lobbyView.truckCollectionView.scrollToItem(
            at: IndexPath(row: indexNum, section: 0),
            at: .centeredHorizontally,
            animated: true)
        
        self.lobbyView.updataMapView(lat: marker.position.latitude, long: marker.position.longitude)

        return true
    }
    
    func didTapMyLocationButton(for mapView: GMSMapView) -> Bool {
        
        if let myLocation = lobbyView.locationManager.location {
            
            self.lobbyView.updataMapView(lat: myLocation.coordinate.latitude,
                                         long: myLocation.coordinate.longitude)
            
        } else {
            print("User's location is unknown")
        }
        return true
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        self.checkPage()
        
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        print("scrollViewDidEndDragging")
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            if !self.lobbyView.truckCollectionView.isDecelerating {
                self.checkPage()
            }
        }
    }
    
    func checkPage() {
        let page = lobbyView.truckCollectionView.contentOffset.x / LobbyView.cardItemSize.width
        
        let roundPage = round(page)
        
        var targetIndex = 0
        
        if page - 0.5 >= roundPage {
            targetIndex = Int(roundPage) + 1
        } else {
            targetIndex = roundPage == 0 || roundPage == -1 ? 0 : Int(roundPage)
        }
        
        lobbyView.truckCollectionView.scrollToItem(at: IndexPath(row: targetIndex, section: 0), at: .centeredHorizontally, animated: true)
        
        let location = FirebaseManager.shared.truckData[targetIndex].location
        
        lobbyView.updataMapView(lat: location.latitude, long: location.longitude)
    }
}
