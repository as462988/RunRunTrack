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

protocol LobbyViewDelegate: UICollectionViewDelegate,
    UICollectionViewDataSource, GMSMapViewDelegate,
CLLocationManagerDelegate, AnyObject {
    
}

class LobbyView: UIView, UICollectionViewDelegate {
    static let cardItemSize: CGSize = CGSize(width: 200, height: 130)
    
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
            
            locationManager.delegate = self.delegate
        }
    }
    
    var locationManager = CLLocationManager() 
    
    lazy var cardLayout: TruckInfoCollectionViewLayout = {
        let layout = TruckInfoCollectionViewLayout()
        layout.itemSize = LobbyView.cardItemSize
        return layout
    }()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        setCollectionView()
        
        setMapView()
        
        getCurrentLocation()
        
        print("contentSize: \(truckCollectionView.contentSize)")
//        self.truckCollectionView.
//        self.truckCollectionView.addObserver(self,
//        forKeyPath: #keyPath(UIScrollView.contentOffset),
//        options: .new, context: nil)

    }
    
    func setMapView() {
        
        let camera = GMSCameraPosition.camera(withLatitude: 25.033128, longitude: 121.565806, zoom: 15)
        mapView.camera = camera
        mapView.settings.myLocationButton = true
        mapView.isMyLocationEnabled = true
        mapView.padding = UIEdgeInsets(top: 0, left: 0, bottom: 160, right: 0)
        
    }
    
    func marker(lat: Double, long: Double) {
        
        let position = CLLocationCoordinate2D(latitude: lat, longitude: long)
        let marker = GMSMarker(position: position)
        marker.icon = UIImage.asset(.Icon_default)
        marker.map = mapView
        
    }
    
    func updataMapView(lat: Double, long: Double) {
        
        let camera = GMSCameraPosition.camera(withLatitude: lat,
                                              longitude: long ,
                                              zoom: 15)
        mapView.animate(to: camera)
    }
    
    func getCurrentLocation() {
        
        locationManager.requestAlwaysAuthorization()
        locationManager.requestWhenInUseAuthorization()
        
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self.delegate
            locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            locationManager.startUpdatingLocation()
            
        }
    }
    
    func getLocation(lat: Double, long: Double, completion: @escaping (CNPostalAddress?, Error?) -> Void) {
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
    
//    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
//        if keyPath == #keyPath(UIScrollView.contentOffset) {
//            if let offset = change?[NSKeyValueChangeKey.newKey] as? CGPoint {
////                print(offset.x.truncatingRemainder(dividingBy: LobbyView.cardItemSize.width) == CGFloat.zero)
////                if offset.x.truncatingRemainder(dividingBy: LobbyView.cardItemSize.width) == CGFloat.zero {
////
////                }
//                print(offset.x)
//            }
//        }
//    }
}
