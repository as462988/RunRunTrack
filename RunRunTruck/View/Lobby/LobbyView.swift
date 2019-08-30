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

protocol LobbyViewDelegate: UICollectionViewDelegate, UICollectionViewDataSource, AnyObject {
    
}

class LobbyView: UIView {

    @IBOutlet weak var truckCollectionView: UICollectionView! {
        
        didSet {
            
            truckCollectionView.dataSource = self.delegate
            
            truckCollectionView.delegate = self.delegate
        }
    }
    
    @IBOutlet weak var mapView: GMSMapView!
    
    weak var delegate: LobbyViewDelegate? {
        
        didSet {
            
            guard let truckCollectionView = truckCollectionView else { return }
            
            truckCollectionView.dataSource = self.delegate
            
            truckCollectionView.delegate = self.delegate
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
        
    }
    
    func marker(lat: Double, long: Double, name: String) {
        let position = CLLocationCoordinate2D(latitude: lat, longitude: long)
        let marker = GMSMarker(position: position)
        marker.icon = UIImage.asset(.Icon_default)
        marker.title = name// 用家按下marker時會顯示出來
        marker.map = mapView

    }
    
    func getLocation(lat: Double, long: Double, completion: @escaping (String) -> Void ) {
        let address = CLGeocoder.init()
        address.reverseGeocodeLocation(CLLocation.init(latitude: lat, longitude: long)) {(places, error) in
            
            var location: String = ""
            
            guard error == nil  else {return}
            
                if let place = places?.first {
                    
                    if let address = place.postalAddress {
                        
                        location = address.subAdministrativeArea + address.city + address.street
                        
                        print(location)
                    }
                }
            
            completion(location)
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
