//
//  CreatQrcodeViewController.swift
//  RunRunTruck
//
//  Created by yueh on 2019/9/17.
//  Copyright © 2019 yueh. All rights reserved.
//

import UIKit

class CreateQrCodeViewController: UIViewController, QrCodeViewDelegate {

    @IBOutlet weak var qrCodeView: QrCodeView! {
        
        didSet {
            qrCodeView.delegate = self
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        guard let rootVC = AppDelegate.shared.window?.rootViewController as? TabBarViewController else { return }
        rootVC.tabBar.isHidden = true
        qrCodeView.layer.cornerRadius = 20
    }
    
    func clickCloseBtn() {
        guard let rootVC = AppDelegate.shared.window?.rootViewController as? TabBarViewController else { return }
        rootVC.tabBar.isHidden = false
        dismiss(animated: false, completion: nil)
    }
}
