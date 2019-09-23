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
    @IBOutlet weak var showLocationTextView: UITextView!
    @IBOutlet weak var storyLabel: UILabel!
    @IBOutlet weak var backBtn: UIButton!
    @IBOutlet weak var backBtnBg: UIView!
    @IBOutlet weak var favoriteBtn: UIButton! {
        didSet{
            favoriteBtn.isSelected = isFavorite
        }
    }
    var touchHandler: (() -> Void)?
    
    var detailInfo: TruckData?
    let dateManager = TransformTimeManager()
    var isFavorite: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setValue()
        backBtn.addTarget(self, action: #selector(backToRoot), for: .touchUpInside)
        favoriteBtn.addTarget(self, action: #selector(clickFavorite), for: .touchUpInside)
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
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
        infoImageView.loadImage(detailInfo.detailImage, placeHolder: UIImage.asset(.Icon_car))
        
        storyLabel.text = detailInfo.story
        
        if detailInfo.openTime == nil {
            
            locationLabel.isHidden = true
            showLocationTextView.isHidden = true
        }
        
        if detailInfo.open {
            locationLabel.text = "現在出沒在..."
            showLocationTextView.text = detailInfo.address
        } else {
            locationLabel.text = "最近出沒在..."
            showLocationTextView.text = detailInfo.address

        }
        
    }
    
    @objc func clickFavorite(_ sender: UIButton) {
        
       guard FirebaseManager.shared.bossID != nil || FirebaseManager.shared.userID != nil  else {

          LKProgressHUD.showFailure(text: "登入會員就可以蒐集徽章囉！")

              return
          }
        
        guard let detailInfo = detailInfo else { return }
        
        let uid = FirebaseManager.shared.bossID
        let bossId = FirebaseManager.shared.userID
        
        sender.isSelected = !sender.isSelected
        
        self.isFavorite = !isFavorite
        
        if isFavorite {
            FirebaseManager.shared.addUserFavorite(
                uid: (uid == nil ? bossId : uid) ?? "",
            truckId: detailInfo.id) {
                print("addSuccess")
            }
        } else {
            FirebaseManager.shared.deleteUserFavorite(
                uid: (uid == nil ? bossId : uid) ?? "",
                truckId: detailInfo.id) {
                    print("deleteSuccess")
            }
        }
    }
    
    @objc func backToRoot() {
        
        self.navigationController?.popViewController(animated: true)
    }
}
