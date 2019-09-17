//
//  AddressManager.swift
//  RunRunTruck
//
//  Created by yueh on 2019/9/17.
//  Copyright © 2019 yueh. All rights reserved.
//

import Foundation
import CoreLocation
import Contacts

class AddressManager {
    
    func getLocationAddress(lat: Double, long: Double, completion: @escaping (CNPostalAddress?, Error?) -> Void) {
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
}
