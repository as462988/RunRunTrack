//
//  TransformTimeManager.swift
//  RunRunTruck
//
//  Created by yueh on 2019/9/19.
//  Copyright © 2019 yueh. All rights reserved.
//

import Foundation

class TransformTimeManager {
    
    func dateToString(time: Double, formatter: String = "yyyy/MM/dd EEEE HH:mm") -> String {
        
            let date: Date = Date(timeIntervalSince1970: time)
        
            let dateFormatter: DateFormatter = DateFormatter()
            
            dateFormatter.dateFormat = formatter
            
            return dateFormatter.string(from: date)
        }
    
}
