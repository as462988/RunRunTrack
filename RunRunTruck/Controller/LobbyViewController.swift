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
      
        FirebaseManager.shared.getTruckData { (data) in
            for (index, dataInfo) in FirebaseManager.shared.truckData.enumerated() {
                
                self.lobbyView.marker(lat: dataInfo.location.latitude,
                                      long: dataInfo.location.longitude,
                                      index: index)
                
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
                      logoImage: data.logoImage,
                      truckLocationText: data.address)
        print(FirebaseManager.shared.truckData[6].logoImage)
        cell.latitude = data.location.latitude
        cell.longitude = data.location.longitude
        cell.layer.cornerRadius = 20
        cell.clipsToBounds = true
        
        return cell
    }
    
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
            
            let alertController = UIAlertController (title: "無法定位", message: "沒有開啟定位系統無法訂位喔！", preferredStyle: .alert)
            
            let settingsAction = UIAlertAction(title: "去設定", style: .default) { (_) -> Void in
                
                guard let settingsUrl = URL(string: UIApplication.openSettingsURLString) else {
                    return
                }
                
                if UIApplication.shared.canOpenURL(settingsUrl) {
                    UIApplication.shared.open(settingsUrl, completionHandler: { (success) in
                        print("Settings opened: \(success)") // Prints true
                    })
                }
            }
            alertController.addAction(settingsAction)
            let cancelAction = UIAlertAction(title: "我知道了", style: .default, handler: nil)
            alertController.addAction(cancelAction)
            
            present(alertController, animated: true, completion: nil)
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
        
        lobbyView.truckCollectionView.scrollToItem(at: IndexPath(row: targetIndex, section: 0),
                                                   at: .centeredHorizontally,
                                                   animated: true)
        
        let location = FirebaseManager.shared.truckData[targetIndex].location
        
        lobbyView.updataMapView(lat: location.latitude, long: location.longitude)
    }
}
