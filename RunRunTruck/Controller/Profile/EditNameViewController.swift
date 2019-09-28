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
        setupNavBar()
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

extension EditNameViewController {
    
    func setupNavBar() {
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
        self.navigationController?.popViewController(animated: true)
    }
}
