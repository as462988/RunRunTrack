//
//  LobbyUIView.swift
//  RunRunTruck
//
//  Created by yueh on 2019/8/28.
//  Copyright © 2019 yueh. All rights reserved.
//

import UIKit
import GoogleMaps

class LobbyView: UIView {
    
    init() {
        super.init(frame: CGRect.zero)
        self.addSubview(googleMap)
        setGoogleMap() 
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
        
    }
    
    var googleMap = GMSMapView()
    
    func setGoogleMap() {
                let camera = GMSCameraPosition.camera(withLatitude: 23.963, longitude: 120.522, zoom: 12.0)
                googleMap.camera = camera
    }
    
}
