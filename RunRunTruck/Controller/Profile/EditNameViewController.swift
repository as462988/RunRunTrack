//
//  EditNameViewController.swift
//  RunRunTruck
//
//  Created by Yueh-chen Hsu on 2019/9/28.
//  Copyright © 2019 yueh. All rights reserved.
//

import UIKit

class EditNameViewController: UIViewController {
    @IBOutlet weak var editNameText: UITextField!
    @IBOutlet weak var saveEditBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        saveEditBtn.addTarget(self, action: #selector(saveEdit), for: .touchUpInside)
    }

    @objc func saveEdit() {
     
        print(#function)
    }
}
