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
    
    // swiftlint:enable identifier_name
}

extension UIImage {
    
    static func asset(_ asset: ImageAsset) -> UIImage? {
        
        return UIImage(named: asset.rawValue)
    }
}
