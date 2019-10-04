//
//  BtnStatus.swift
//  RunRunTruck
//
//  Created by yueh on 2019/9/9.
//  Copyright © 2019 yueh. All rights reserved.
//

import Foundation
import UIKit

enum BtnStatus {
    
    case enable
    
    case disable
}

// MARK: - 設置 Btn 狀態
func setBtnStatus(_ status: BtnStatus, btn: UIButton) {
    switch status {
    case .enable:
        
        btn.isUserInteractionEnabled = true
        
        btn.alpha = 1
        
    case .disable:
        
        btn.isUserInteractionEnabled = false
        
        btn.alpha = 0.5
    }
}
