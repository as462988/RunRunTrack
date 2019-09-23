//
//  SettingViewController.swift
//  RunRunTruck
//
//  Created by yueh on 2019/9/9.
//  Copyright © 2019 yueh. All rights reserved.
//

import UIKit

class SettingViewController: UIViewController {
    
    @IBOutlet weak var setingTableiew: UITableView! {
        didSet {
            setingTableiew.delegate = self
            setingTableiew.dataSource = self
        }
    }
    
    let header: [String] = ["封鎖名單", "隱私條約", "意見回饋", "登出"]
    
    var block: [String] = ["", "", ""]

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

extension SettingViewController: UITableViewDelegate, UITableViewDataSource {
   
  func numberOfSections(in tableView: UITableView) -> Int {
    return header.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return block.count
        } else {
            return 0
        }
    }

    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return header[section]
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        if section == 0 {
            let headerView = UITableViewHeaderFooterView()
            let gesture = UITapGestureRecognizer(target: self, action: #selector(didTapHeader))
            headerView.addGestureRecognizer(gesture)
            return headerView
        }
        
        return UIView()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let settingCell = tableView.dequeueReusableCell(
            withIdentifier: "settingCell", for: indexPath) as? BlockTableViewCell else {
            return UITableViewCell()
        }
        settingCell.backgroundColor = .red
        return settingCell
    }

    @objc func didTapHeader() {
        
        print("TAP TAP")
//
//        setingTableiew.beginUpdates()
//        block = []
//        setingTableiew.endUpdates()
//
    }
}
