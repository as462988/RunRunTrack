//
//  QrcodeView.swift
//  RunRunTruck
//
//  Created by yueh on 2019/9/17.
//  Copyright © 2019 yueh. All rights reserved.
//

import UIKit

protocol QrcodeViewDelegate: AnyObject {
    func clickCloseBtn()
}

class QrcodeView: UIView {
    
    @IBOutlet weak var qrcodeImage: UIImageView!
    @IBOutlet weak var closeBtn: UIButton!
    @IBOutlet weak var timeLabel: UILabel!
    
    var timer = Timer()
    var count = 30
    
   weak var delegate: QrcodeViewDelegate?

    override func awakeFromNib() {
        setValue()
        timer = Timer.scheduledTimer(timeInterval: 1,
                                     target: self,
                                     selector: #selector(updateTime),
                                     userInfo: nil, repeats: true)
        closeBtn.addTarget(self, action: #selector(clickCloseBtn), for: .touchUpInside)
    }
    
    @objc func updateTime() {

        if count == 0 {
            stop()
        } else if count < 10 {
            
            count -= 1
            timeLabel.text = " 0 : 0\(count)"
        } else {
            
            count -= 1
            timeLabel.text = " 0 : \(count)"
        }
    }
    
    func stop() {
        
        timer.invalidate()
        
        count = 0
        
        timeLabel.text = "Qrcode 失效囉！"

    }
    
    func setValue() {
        
        guard let truckId = FirebaseManager.shared.bossTruck?.id else {
            return
        }
        closeBtn.layer.cornerRadius = 20
        closeBtn.clipsToBounds = true
        qrcodeImage.image = generateQRCode(from: truckId)
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
