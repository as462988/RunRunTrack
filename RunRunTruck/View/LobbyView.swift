//
//  LobbyView.swift
//  RunRunTruck
//
//  Created by yueh on 2019/8/28.
//  Copyright © 2019 yueh. All rights reserved.
//

import UIKit
import GoogleMaps

class LobbyView: UIView {

    var mapView = GMSMapView()
    
    override init(frame: CGRect) {
        super.init(frame: CGRect.zero)
        self.addSubview(mapView)
        self.backgroundColor = .blue
        setMapViewLayout()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setMapViewLayout() {
        mapView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            mapView.topAnchor.constraint(equalTo: self.topAnchor),
            mapView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            mapView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            mapView.bottomAnchor.constraint(equalTo: self.bottomAnchor)
            ])
        
        print("aaaa")
        let camera = GMSCameraPosition.camera(withLatitude: 23.963, longitude: 120.522, zoom: 12.0)
        mapView.camera = camera
    }
}
