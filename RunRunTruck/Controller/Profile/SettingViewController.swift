//
//  SettingViewController.swift
//  RunRunTruck
//
//  Created by yueh on 2019/9/9.
//  Copyright © 2019 yueh. All rights reserved.
//

import UIKit

class SettingViewController: UIViewController {
    var contentScrollerView: UIScrollView!
    var contentView: UIView!
    var titleLabel: UILabel!
    
    var blockRow: SettingRow = {
        let row = SettingRow(type: .system)
        row.backgroundColor = .white
        row.setupViews()
        row.customTitleLabel.text = "封鎖名單"
        return row
    }()
    var privateCheckRow: SettingRow = {
        let row = SettingRow(type: .custom)
        row.backgroundColor = .white
        row.setupViews()
        row.customTitleLabel.text = "隱私權政策"
        return row
    }()
    var feebackRow: SettingRow = {
        let row = SettingRow(type: .custom)
        row.backgroundColor = .white
        row.setupViews()
        row.customTitleLabel.text = "意見回饋"
        return row
    }()
    var versionRow: SettingRow = {
        let row = SettingRow(type: .custom)
        row.backgroundColor = .white
        row.setupViews()
        row.customTitleLabel.text = "版本"
        return row
    }()
    var logoutRow: SettingRow = {
        let row = SettingRow(type: .custom)
        row.backgroundColor = .white
        row.setupViews()
        row.customTitleLabel.text = "登出"
        return row

    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupNavBar()
        setupViews()
    }
    
    @objc func backToRoot() {
        self.navigationController?.popViewController(animated: true)
    }
    
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
    
    func setupViews() {
        
        contentScrollerView = UIScrollView()
        contentScrollerView.alwaysBounceVertical = true
        
        view.addSubview(contentScrollerView)
        contentScrollerView.translatesAutoresizingMaskIntoConstraints = false
        contentScrollerView.topAnchor.constraint(
            equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        contentScrollerView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        contentScrollerView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        contentScrollerView.bottomAnchor.constraint(
            equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true
        contentScrollerView.backgroundColor = .white
        
        contentView = UIView()
        contentScrollerView.addSubview(contentView)
        contentView.frame = view.frame
//        contentView.translatesAutoresizingMaskIntoConstraints = false
//        contentView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
//        contentView.leadingAnchor.constraint(equalTo: contentScrollerView.leadingAnchor).isActive = true
//        contentView.bottomAnchor.constraint(equalTo: contentScrollerView.bottomAnchor).isActive = true
//        contentView.trailingAnchor.constraint(equalTo: contentScrollerView.trailingAnchor).isActive = true
//        contentScrollerView.contentSize = contentView.bounds.size
        
//        contentView.frame = contentScrollerView.frame
        contentView.backgroundColor = .lightGray
        contentScrollerView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        
        titleLabel = UILabel()
        titleLabel.text = "設定"
        titleLabel.font = .boldSystemFont(ofSize: 30)
        contentView.addSubview(titleLabel)
        titleLabel.anchor(
            top: contentView.topAnchor,
            leading: contentView.leadingAnchor,
            bottom: nil,
            trailing: nil,
            padding: .init(top: 15, left: 20, bottom: 0, right: 0), size: .zero)
        //Rows
        contentView.addSubview(blockRow)
        blockRow.translatesAutoresizingMaskIntoConstraints = false
        blockRow.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 20).isActive = true
        blockRow.leadingAnchor.constraint(equalTo: contentView.leadingAnchor).isActive = true
        blockRow.trailingAnchor.constraint(equalTo: contentView.trailingAnchor).isActive = true
        blockRow.heightAnchor.constraint(equalToConstant: 75).isActive = true
//        blockRow.anchor(
//            top: nil,
//            leading: contentView.leadingAnchor,
//            bottom: nil,
//            trailing: contentView.trailingAnchor)
//        contentView.addSubview(privateCheckRow)
//        privateCheckRow.anchor(
//            top: blockRow.bottomAnchor,
//            leading: contentView.leadingAnchor,
//            bottom: nil,
//            trailing: contentView.trailingAnchor)
//        contentView.addSubview(feebackRow)
//        feebackRow.anchor(
//            top: privateCheckRow.bottomAnchor,
//            leading: contentView.leadingAnchor,
//            bottom: nil,
//            trailing: contentView.trailingAnchor)
//        contentView.addSubview(versionRow)
//        versionRow.anchor(
//            top: feebackRow.bottomAnchor,
//            leading: contentView.leadingAnchor,
//            bottom: nil,
//            trailing: contentView.trailingAnchor)
//        contentView.addSubview(logoutRow)
//        logoutRow.anchor(
//            top: versionRow.bottomAnchor,
//            leading: contentView.leadingAnchor,
//            bottom: nil,
//            trailing: contentView.trailingAnchor)
        blockRow.addTarget(self, action: #selector(toggleBlockList), for: .touchUpInside)
//        privateCheckRow.addTarget(self, action: #selector(showPrivatePolicy), for: .touchUpInside)
//        feebackRow.addTarget(self, action: #selector(showFeeback), for: .touchUpInside)
////        versionRow.addTarget(self, action: #selector(toggleBlockList), for: .touchUpInside)
//        logoutRow.addTarget(self, action: #selector(logout), for: .touchUpInside)
    }
    
    @objc func toggleBlockList() {
        print(#function)
    }
    
    @objc func showPrivatePolicy() {
        print(#function)
    }
    
    @objc func showFeeback() {
        print(#function)
    }
    
    @objc func logout() {
        print(#function)
    }
}
