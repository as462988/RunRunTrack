//
//  GMSMarker+Extension.swift
//  RunRunTruck
//
//  Created by yueh on 2019/9/1.
//  Copyright © 2019 yueh. All rights reserved.
//
import UIKit

extension UIColor {
    
    convenience init(r: CGFloat,
                     g: CGFloat,
                     b: CGFloat) {
        
        self.init(red: r/255, green: g/255, blue: b/255, alpha: 1)
    }

    static func hexStringToUIColor(hex: String) -> UIColor {
        
        var cString: String = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
        
        if cString.hasPrefix("#") {
            cString.remove(at: cString.startIndex)
        }
        
        if (cString.count) != 6 {
            return UIColor.gray
        }
        
        var rgbValue: UInt32 = 0
        Scanner(string: cString).scanHexInt32(&rgbValue)
        
        return UIColor(
            red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
            alpha: CGFloat(1.0)
        )
    }
}
