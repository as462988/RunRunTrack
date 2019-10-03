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
    @IBOutlet weak var favoriteBtn: UIButton!
 
    var detailInfo: TruckData?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setValue()
        backBtn.addTarget(self, action: #selector(backToRoot), for: .touchUpInside)
        favoriteBtn.addTarget(self, action: #selector(clickFavorite), for: .touchUpInside)
        if let user = FirebaseManager.shared.currentUser, let detailInfo = detailInfo {
            favoriteBtn.isSelected = user.favorite.contains(detailInfo.id)
        }
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
        
        if FirebaseManager.shared.bossID != nil {
            favoriteBtn.isHidden = true
        }
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
            
            ProgressHUD.showFailure(text: "登入會員就可以蒐集喜愛清單囉！")
            
            return
        }
        
        guard let detailInfo = detailInfo else { return }
        
        let uid = FirebaseManager.shared.userID
        let bossId = FirebaseManager.shared.bossID
        let topic = detailInfo.id
        sender.isSelected = !sender.isSelected
        if sender.isSelected {
            
            //喜愛時訂閱推播
            FirebaseNotificationManager.share.subscribeTopic(toTopic: topic, completion: nil)
            print("topicName:\(topic)")
            
            FirebaseManager.shared.updataArrayData(
                type: User.user.rawValue,
                id: (uid == nil ? bossId : uid) ?? "",
                key: User.favorite.rawValue,
                value: detailInfo.id) {
                    FirebaseManager.shared.updataArrayData(
                        type: Truck.truck.rawValue,
                        id: detailInfo.id,
                        key: Truck.favoritedBy.rawValue,
                        value: (uid == nil ? bossId : uid) ?? "") {}
            }
        } else {
            
            FirebaseNotificationManager.share.unSubscribeTopic(fromTopic: topic, completion: nil)
            FirebaseManager.shared.updataRemoveArrayData(
                type: User.user.rawValue,
                id: (uid == nil ? bossId : uid) ?? "",
                key: User.favorite.rawValue,
                value: detailInfo.id) {
                    FirebaseManager.shared.updataRemoveArrayData(
                        type: Truck.truck.rawValue,
                        id: detailInfo.id,
                        key: Truck.favoritedBy.rawValue,
                        value: (uid == nil ? bossId : uid) ?? "", completion: {})
            }
        }
    }
    
    @objc func backToRoot() {
        
        self.navigationController?.popViewController(animated: true)
    }
}
