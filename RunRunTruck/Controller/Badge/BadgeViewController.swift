//
//  BadgeViewController.swift
//  RunRunTruck
//
//  Created by yueh on 2019/9/17.
//  Copyright © 2019 yueh. All rights reserved.
//

import UIKit

class BadgeViewController: UIViewController {
    
    @IBOutlet weak var button: UIButton!
    @IBOutlet weak var badgeCollectionView: UICollectionView! {
        
        didSet {
            badgeCollectionView.delegate = self
            badgeCollectionView.dataSource = self
        }
    }
    
    var badgeArr: [TruckBadge] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        FirebaseManager.shared.getAllLogoImage { [weak self] (truckDatas) in
            guard let truckDatas = truckDatas else { return }
            
            for truckData in truckDatas {
                
                self?.badgeArr.append(truckData)
            }
            
            self?.getUserBadgeisAchieved()
            
            DispatchQueue.main.async {
                self?.badgeCollectionView.reloadData()
            }
        }

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        guard let rootVC = AppDelegate.shared.window?.rootViewController
            as? TabBarViewController else { return }
        rootVC.tabBar.isHidden = false
    }
    
    func getUserBadgeisAchieved() {
        
        guard let user = FirebaseManager.shared.currentUser else {
            return
        }
        
        for (index, id) in badgeArr.enumerated() {
            
            if user.badge.contains(id.truckId) {
                
                badgeArr[index].isAchieved = true
            }
        }
        
    }
    
    @IBAction func animateButton(sender: UIButton) {
        
//        sender.transform = CGAffineTransform(scaleX: 0.6, y: 0.6)
//
//        UIView.animate(withDuration: 2.0,
//                       delay: 0,
//                       usingSpringWithDamping: CGFloat(0.20),
//                       initialSpringVelocity: CGFloat(6.0),
//                       options: UIView.AnimationOptions.allowUserInteraction,
//                       animations: {
//                        sender.transform = CGAffineTransform.identity
//        },
//                       completion: { Void in()  }
//        )
        
       guard FirebaseManager.shared.bossID != nil || FirebaseManager.shared.userID != nil  else {
        
            print("請先登入會員")
        
            return
        }
        
        guard let rootVC = AppDelegate.shared.window?.rootViewController
            as? TabBarViewController else { return }
        rootVC.tabBar.isHidden = true
        
        let vc = UIStoryboard.badge.instantiateViewController(withIdentifier: "scannerVC")
        show(vc, sender: nil)

    }
}

extension BadgeViewController:
UICollectionViewDelegate,
UICollectionViewDataSource,
UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return badgeArr.count
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let badgeCell = collectionView.dequeueReusableCell(
            withReuseIdentifier: "badgeCell", for: indexPath) as? BadgeCollectionViewCell else {
            return UICollectionViewCell()
        }
        
         badgeCell.setValue(logo: badgeArr[indexPath.item].logoImage, name: badgeArr[indexPath.item].name)
        
        if badgeArr[indexPath.item].isAchieved {
            
            badgeCell.changeLayout(alpha: 1)
            
        } else {
            
            badgeCell.changeLayout(alpha: 0.2)
        }
       
        return badgeCell
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let itemSize = CGSize(
            width: UIScreen.main.bounds.width / 2 - 20,
            height: UIScreen.main.bounds.width / 2 - 20)
        
        return itemSize
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        insetForSectionAt section: Int) -> UIEdgeInsets {
        let cellLocation = UIEdgeInsets(top: 24, left: 16, bottom: 0, right: 16)
        
        return cellLocation
    }
    
}
