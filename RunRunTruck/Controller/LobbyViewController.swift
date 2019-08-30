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
    
    func mapView(_ mapView: GMSMapView, didTap marker: GMSMarker) -> Bool {
        
        var indexNum = Int()
        
        for (index, data) in FirebaseManager.shared.truckData.enumerated() {
            
            if marker.position.latitude == data.location.latitude {
                
                indexNum = index
            }
        }
        
        self.lobbyView.truckCollectionView.scrollToItem(
            at: IndexPath(row: indexNum, section: 0),
            at: .centeredHorizontally,
            animated: true)
        
        let camera = GMSCameraPosition.camera(withLatitude: marker.position.latitude,
                                              longitude: marker.position.longitude ,
                                              zoom: 15)
        mapView.animate(to: camera)
        
        return true
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        guard let locValue: CLLocationCoordinate2D = manager.location?.coordinate else { return }
        
        print("locations = \(locValue.latitude) \(locValue.longitude)")
    }
    
    func didTapMyLocationButton(for mapView: GMSMapView) -> Bool {
        
        if let myLocation = lobbyView.locationManager.location {
            
            let camera = GMSCameraPosition.camera(withLatitude: myLocation.coordinate.latitude,
                                                  longitude: myLocation.coordinate.longitude ,
                                                  zoom: 15)
            mapView.animate(to: camera)
            
        } else {
            print("User's location is unknown")
        }
        return true
    }
    
}
