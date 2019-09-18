//
//  UIImage+Extension.swift
//  RunRunTruck
//
//  Created by yueh on 2019/8/27.
//  Copyright © 2019 yueh. All rights reserved.
//

import UIKit

enum ImageAsset: String {
    
     // swiftlint:disable identifier_name
    case Icon_default
    
    case Icon_logo
    
    case Icon_home
    
    case Icon_info
    
    case Icon_car
    
    case Icon_brdge
    
    case Icon_profile
    
    case Icon_button
    
    case Icon_back
    
    case Icon_whiteBack
    
    case Icon_cancel
    
    case Icon_UserImage
    // swiftlint:enable identifier_name
}

extension UIImage {
    
    static func asset(_ asset: ImageAsset) -> UIImage? {
        
        return UIImage(named: asset.rawValue)
    }
}
