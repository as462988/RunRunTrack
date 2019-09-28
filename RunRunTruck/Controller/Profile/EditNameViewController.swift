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
    
    var name: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        editNameText.placeholder = self.name
        saveEditBtn.addTarget(self, action: #selector(saveEdit), for: .touchUpInside)
    }

    @objc func saveEdit() {
        
        if editNameText.text == "" {
            editNameText.text = name
        }
        guard let text = editNameText.text else { return }
        FirebaseManager.shared.updataUserName(name: text)
        
        DispatchQueue.main.async {
            self.navigationController?.popViewController(animated: true)
        }
    }
}
