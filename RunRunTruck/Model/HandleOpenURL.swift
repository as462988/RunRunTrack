//
//  HandleOpenURL.swift
//  RunRunTruck
//
//  Created by Yueh-chen Hsu on 2019/10/3.
//  Copyright © 2019 yueh. All rights reserved.
//

import Foundation
import UIKit

class HandleOpenURL {
    
    private struct NavLocation {
        
        static let saddr = "?saddr="
        static let daddr = "&daddr="
        static let center = "&center="
        static let type = "&directionsmode="
        static let drive = "driving"
        static let zoom = "&zoom="
    }
    
    func openUrl(lat: Double, lon: Double, zoom: Float) {
        
        let daddrLocation = NavLocation.daddr + "\(lat),\(lon)"
        
        let centerLocation = NavLocation.center + "\(lat),\(lon)"
        
        let type = NavLocation.type + NavLocation.drive
        
        let zoom = NavLocation.zoom + "\(zoom)"
        
        let googleURL = Bundle.ValueForString(key: Constant.openGooleMapURL)
        
        guard let openUrl = URL(string: googleURL) else {return}
        
        if UIApplication.shared.canOpenURL(openUrl) {
            
            guard let url = URL(string: googleURL + NavLocation.saddr + daddrLocation + centerLocation + type + zoom)
                else {
                    return
            }
            
            UIApplication.shared.open(url)
        }
    }
}
