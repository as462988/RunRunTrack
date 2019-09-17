//
//  QrcodeView.swift
//  RunRunTruck
//
//  Created by yueh on 2019/9/17.
//  Copyright © 2019 yueh. All rights reserved.
//

import UIKit

class QrcodeView: UIView {
    
    @IBOutlet weak var qrcodeImage: UIImageView!
    @IBOutlet weak var closeBtn: UIButton!
    @IBOutlet weak var timeLabel: UILabel!
    
    var timer = Timer()
    var count = 30

    override func awakeFromNib() {
        setValue()
        timer = Timer.scheduledTimer(timeInterval: 1,
                                     target: self,
                                     selector: #selector(updateTime),
                                     userInfo: nil, repeats: true)
    }
    
    @objc func updateTime() {
        count -= 1
        timeLabel.text = " 0: \(count)"
    }
    
    func setValue() {
        closeBtn.layer.cornerRadius = 20
        closeBtn.clipsToBounds = true
        qrcodeImage.image = generateQRCode(from: "hahahahahahahahahaaaaaa")
    }
    
    func generateQRCode(from string: String) -> UIImage? {
        let data = string.data(using: String.Encoding.ascii)
        
        if let filter = CIFilter(name: "CIQRCodeGenerator") {
            filter.setValue(data, forKey: "inputMessage")
            let transform = CGAffineTransform(scaleX: 5, y: 5)
            
            if let output = filter.outputImage?.transformed(by: transform) {
                return UIImage(ciImage: output)
            }
        }
        
        return nil
    }
}
