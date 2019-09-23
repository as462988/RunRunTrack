//
//  SettingViewController.swift
//  RunRunTruck
//
//  Created by yueh on 2019/9/9.
//  Copyright © 2019 yueh. All rights reserved.
//

import UIKit

class SettingViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.barTintColor = .white
        navigationItem.leftBarButtonItem = UIBarButtonItem(
            image: UIImage.asset(.Icon_back),
            style: .plain,
            target: self,
            action: #selector(backToRoot))
        let image = UIImage()
             self.navigationController?.navigationBar.setBackgroundImage(image, for: .default)
        self.navigationController?.navigationBar.shadowImage = image
        
    }

    @objc func backToRoot() {

           self.navigationController?.popViewController(animated: false)
       }
    
}
