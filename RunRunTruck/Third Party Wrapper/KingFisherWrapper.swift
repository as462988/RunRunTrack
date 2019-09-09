//
//  KingFisherWrapper.swift
//  RunRunTruck
//
//  Created by yueh on 2019/8/29.
//  Copyright © 2019 yueh. All rights reserved.
//

import UIKit
import Kingfisher

extension UIImageView {
    
    func loadImage(_ urlString: String?, placeHolder: UIImage? = nil) {
        
        guard urlString != nil else { return }
        
        let url = URL(string: urlString!)
        
        self.kf.setImage(with: url, placeholder: placeHolder)

    }
}
