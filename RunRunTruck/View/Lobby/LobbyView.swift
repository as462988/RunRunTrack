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
    
    static let cardItemSize: CGSize = CGSize(width: 200, height: 150)
    var markers: [GMSMarker] = []
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
        
//        setMapView()
        
        getCurrentLocation()
        
    }
    
    func setMapView(lat: Double, lon: Double, zoom: Float) {
        
        let camera = GMSCameraPosition.camera(withLatitude: lat, longitude: lon, zoom: zoom)
        mapView.camera = camera
        mapView.settings.myLocationButton = true
        mapView.isMyLocationEnabled = true
        mapView.padding = UIEdgeInsets(top: 0, left: 0, bottom: 200, right: 0)
        
    }
    
    func addMarker(lat: Double, long: Double, imageUrl: String) {
        let marker = GMSMarker(position: CLLocationCoordinate2D(latitude: lat, longitude: long))
        markers.append(marker)
        if let url = URL(string: imageUrl) {
            
            URLSession.shared.dataTask(with: url) { [weak self] (data, rsp, err) in
                
                guard let data = data else { return }
                
                DispatchQueue.main.async {
                    
                    guard let img = UIImage(data: data) else {return}
                    
                    self?.setIconImage(marker: marker, img: img)
                }
                }.resume()
        } else {
            guard let img = UIImage.asset(.Icon_logo) else {return}
            self.setIconImage(marker: marker, img: img)
        }
    }
    
    func marker(lat: Double, long: Double, index: Int) {
        
        let iconImage = FirebaseManager.shared.openIngTruckData[index].logoImage
        
        let marker = GMSMarker(position: CLLocationCoordinate2D(latitude: lat, longitude: long))
        
        if let url = URL(string: iconImage) {
            
            URLSession.shared.dataTask(with: url) { [weak self] (data, rsp, err) in
                
                guard let data = data else { return }
                
                DispatchQueue.main.async {
                    
                    guard let img = UIImage(data: data) else {return}
                    
                     self?.setIconImage(marker: marker, img: img)
                }
            }.resume()
        } else {
            
            guard let img = UIImage.asset(.Icon_logo) else {return}
            
            self.setIconImage(marker: marker, img: img)
            
        }
    }
    
    func setIconImage(marker: GMSMarker, img: UIImage) {
        
        let img = img
        let imgView = UIImageView(image: img)
        imgView.frame.size = CGSize(width: 50, height: 50)
        imgView.contentMode = .scaleAspectFill
        imgView.layer.cornerRadius = 25
        imgView.clipsToBounds = true
        marker.iconView = imgView
        marker.tracksViewChanges = true
        marker.map = self.mapView
        
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
    
    func reloadData() {
        
        truckCollectionView.reloadData()
    }
    
    private func setCollectionView() {
        truckCollectionView.showsHorizontalScrollIndicator = false
        truckCollectionView.collectionViewLayout = cardLayout
    }

}
