//
//  LobbyView.swift
//  RunRunTruck
//
//  Created by yueh on 2019/8/28.
//  Copyright © 2019 yueh. All rights reserved.
//

import UIKit
import GoogleMaps

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
        
        let camera = GMSCameraPosition.camera(withLatitude: 123.123123, longitude: 123.123123, zoom: 15)
        mapView.camera = camera
    }
    
    func marker(){
        let position = CLLocationCoordinate2D(latitude: lat, longitude: long)  // lat & long must be Double
        let marker = GMSMarker(position: position)
        marker.title = "Hello World"  // 用家按下marker時會顯示出來
        marker.map = routeDetailMapView
    }
    
    func reloadData() {

        truckCollectionView.reloadData()
    }
    
    private func setCollectionView() {
        truckCollectionView.showsHorizontalScrollIndicator = false
        truckCollectionView.collectionViewLayout = cardLayout
    }
}
