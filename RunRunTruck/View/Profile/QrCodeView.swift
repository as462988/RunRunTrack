//
//  QrCodeView.swift
//  RunRunTruck
//
//  Created by yueh on 2019/9/17.
//  Copyright © 2019 yueh. All rights reserved.
//

import UIKit

protocol QrCodeViewDelegate: AnyObject {
    func clickCloseBtn()
}

class QrCodeView: UIView {
    
    @IBOutlet weak var qrCodeImage: UIImageView!
    @IBOutlet weak var closeBtn: UIButton!
    @IBOutlet weak var timeLabel: UILabel!
    
    var timer = Timer()
    var count = 30
    
   weak var delegate: QrCodeViewDelegate?

    override func awakeFromNib() {
        setLayout()
        timer = Timer.scheduledTimer(timeInterval: 1,
                                     target: self,
                                     selector: #selector(updateTime),
                                     userInfo: nil, repeats: true)
        closeBtn.addTarget(self, action: #selector(clickCloseBtn), for: .touchUpInside)
    }
    
    @objc func updateTime() {
        
        guard let truckId = FirebaseManager.shared.bossTruck?.id else {
            return
        }

        if count == 0 {
            stop()
            qrCodeImage.image = generateQRCode(from: "連結失效囉！")
            
        } else if count < 10 {
            
            count -= 1
            timeLabel.text = " 0 : 0\(count)"
            qrCodeImage.image = generateQRCode(from: truckId)
        } else {
            
            count -= 1
            timeLabel.text = " 0 : \(count)"
            qrCodeImage.image = generateQRCode(from: truckId)
        }
    }
    
    func stop() {
        
        timer.invalidate()
        
        count = 0
        
        timeLabel.text = "Qrcode 失效囉！"

    }
    
    func setLayout() {
        
        closeBtn.layer.cornerRadius = 20
        closeBtn.clipsToBounds = true
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
    
    @objc func clickCloseBtn() {
        self.delegate?.clickCloseBtn()
    }
}
