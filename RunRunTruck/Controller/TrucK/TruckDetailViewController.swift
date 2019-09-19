//
//  TruckDetailViewController.swift
//  RunRunTruck
//
//  Created by yueh on 2019/9/19.
//  Copyright © 2019 yueh. All rights reserved.
//

import UIKit

class TruckDetailViewController: UIViewController {
    
    @IBOutlet weak var infoImageView: UIImageView!
    @IBOutlet weak var logoImageView: UIImageView!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var showLocationLabel: UILabel!
    @IBOutlet weak var showTimeLabel: UILabel!
    
    @IBOutlet weak var storyLabel: UILabel!
    
    @IBOutlet weak var backBtn: UIButton!
    @IBOutlet weak var backBtnBg: UIView!
    
    var detailInfo: TruckData?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setValue()
        backBtn.addTarget(self, action: #selector(backToRoot), for: .touchUpInside)
    }
    
    func setLayout() {
        logoImageView.layer.cornerRadius = logoImageView.bounds.height / 2
        logoImageView.layer.masksToBounds = false
        logoImageView.clipsToBounds = true
        backBtnBg.layer.cornerRadius = backBtnBg.frame.width / 2
        backBtnBg.clipsToBounds = true
        
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        setLayout()
    }
    
    func setValue() {
        guard let detailInfo = detailInfo else { return }
        
        logoImageView.loadImage(detailInfo.logoImage, placeHolder: UIImage.asset(.Icon_logo))
        
        storyLabel.text = detailInfo.story
        showLocationLabel.text = detailInfo.address
        showTimeLabel.text = ""
        
    }
    
    @objc func backToRoot() {
        
        self.navigationController?.popViewController(animated: true)
    }
}
