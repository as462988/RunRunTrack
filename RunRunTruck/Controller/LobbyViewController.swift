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
                                      name: dataInfo.name)
                
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
 
    func mapView(_ mapView: GMSMapView, didTap marker: GMSMarker) -> Bool {
        print(marker.position.latitude)
        
        self.lobbyView.truckCollectionView.scrollToItem(
            at: IndexPath(row: 2, section: 0),
            at: .centeredHorizontally,
            animated: true)
        
        lobbyView.reloadData()
        return true
    }
    
    func mapView(_ mapView: GMSMapView, didTapInfoWindowOf marker: GMSMarker) {
         print("我被按了～～～")
    }
    
    func didTapMyLocationButton(for mapView: GMSMapView) -> Bool {
        print("按我按我")
        return true
    }
    
}
