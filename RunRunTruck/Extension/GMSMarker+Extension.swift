//
//  GMSMarker+Extension.swift
//  RunRunTruck
//
//  Created by yueh on 2019/9/1.
//  Copyright © 2019 yueh. All rights reserved.
//

import GoogleMaps

extension GMSMarker {
    func setIconSize(scaledToSize newSize: CGSize) {
        UIGraphicsBeginImageContextWithOptions(newSize, false, 0.0)
        
        icon?.draw(in: CGRect(x: 0, y: 0, width: newSize.width, height: newSize.height))
        
        let newImage: UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        
        UIGraphicsEndImageContext()
        
        icon = newImage
    }
}
