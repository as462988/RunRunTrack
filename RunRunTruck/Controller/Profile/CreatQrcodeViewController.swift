//
//  CreatQrcodeViewController.swift
//  RunRunTruck
//
//  Created by yueh on 2019/9/17.
//  Copyright © 2019 yueh. All rights reserved.
//

import UIKit

class CreatQrcodeViewController: UIViewController {

    @IBOutlet weak var qrcodeView: QrcodeView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        guard let rootVC = AppDelegate.shared.window?.rootViewController as? TabBarViewController else { return }
        rootVC.tabBar.isHidden = true
        qrcodeView.layer.cornerRadius = 20
    }

}
