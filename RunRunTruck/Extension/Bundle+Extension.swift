//
//  Bundle+Extension.swift
//  RunRunTruck
//
//  Created by yueh on 2019/8/29.
//  Copyright © 2019 yueh. All rights reserved.
//

import Foundation

extension Bundle {
    // swiftlint:disable force_cast
    static func ValueForString(key: String) -> String {
        
        return Bundle.main.infoDictionary![key] as! String
    }
    // swiftlint:enable force_cast
}
