//
//  LobbyView.swift
//  RunRunTruck
//
//  Created by yueh on 2019/8/28.
//  Copyright © 2019 yueh. All rights reserved.
//

import UIKit
import GoogleMaps
import CoreLocation
import Contacts

protocol LobbyViewDelegate: UICollectionViewDelegate, UICollectionViewDataSource, AnyObject, GMSMapViewDelegate {
    
}

class LobbyView: UIView {

    @IBOutlet weak var truckCollectionView: UICollectionView! {
        
        didSet {
            
            truckCollectionView.dataSource = self.delegate
            
            truckCollectionView.delegate = self.delegate
        }
    }
    
    @IBOutlet weak var mapView: GMSMapView! {
        
         didSet {
            
         mapView.delegate = self.delegate
            
        }
    }
    
    weak var delegate: LobbyViewDelegate? {
        
        didSet {
            
            guard let truckCollectionView = truckCollectionView else { return }
            
            truckCollectionView.dataSource = self.delegate
            
            truckCollectionView.delegate = self.delegate
            
            mapView.delegate = self.delegate
        }
    }
    
    lazy var cardLayout: TruckInfoCollectionViewLayout = {
        let layout = TruckInfoCollectionViewLayout()
        layout.itemSize = CGSize(width: 200, height: 130)
        return layout
    }()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setCollectionView()
        
        let camera = GMSCameraPosition.camera(withLatitude: 25.033128, longitude: 121.565806, zoom: 15)
        mapView.camera = camera
        mapView.settings.myLocationButton = true
        
    }
    
    func marker(lat: Double, long: Double, name: String) {
        let position = CLLocationCoordinate2D(latitude: lat, longitude: long)
        let marker = GMSMarker(position: position)
        marker.icon = UIImage.asset(.Icon_default)
        marker.title = name// 用家按下marker時會顯示出來
        marker.map = mapView

    }

    func getLocation(lat: Double, long: Double, completion: @escaping (CNPostalAddress?, Error?) -> ()) {
        let locale = Locale(identifier: "zh_TW")

        let loc: CLLocation = CLLocation(latitude: lat, longitude: long)

            CLGeocoder().reverseGeocodeLocation(loc, preferredLocale: locale) { placemarks, error in

                guard let placemark = placemarks?.first, error == nil else {

                    UserDefaults.standard.removeObject(forKey: "AppleLanguages")

                     completion(nil, error)

                    return
                }
                 completion(placemark.postalAddress, nil)
            }
    }
    
    func reloadData() {

        truckCollectionView.reloadData()
    }
    
    private func setCollectionView() {
        truckCollectionView.showsHorizontalScrollIndicator = false
        truckCollectionView.collectionViewLayout = cardLayout
    }
}
