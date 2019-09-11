//
//  TruckListViewController.swift
//  RunRunTruck
//
//  Created by yueh on 2019/8/30.
//  Copyright © 2019 yueh. All rights reserved.
//

import UIKit

class ProfileViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print("我出現了")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        getBossTruckData()
        
        if FirebaseManager.shared.bossID != nil {
            
            guard let bossVc = UIStoryboard.profile.instantiateViewController(
                withIdentifier: "BossInfoViewController") as? BossInfoViewController else { return }
            
            show(bossVc, sender: nil)
            
        } else {
            
            guard let userVc = UIStoryboard.profile.instantiateViewController(
                withIdentifier: "UserInfoViewController") as? UserInfoViewController else { return }
            
            show(userVc, sender: nil)
            
        }
        
    }
    
    func getBossTruckData() {
        
        guard FirebaseManager.shared.bossID != nil else {
            return
        }
        
        FirebaseManager.shared.getBossTruck()
        
    }
//
//    override func viewWillAppear(_ animated: Bool) {
//        super.viewWillAppear(animated)
//        
//        if FirebaseManager.shared.bossID == nil {
//            userUIView.isHidden = false
//            bossUIView.isHidden = true
//            
//        } else {
//            userUIView.isHidden = true
//            bossUIView.isHidden = false
//            
//            guard FirebaseManager.shared.currentUser?.truckId == nil ||
//                FirebaseManager.shared.currentUser?.truckId == ""
//                else {
//                    
//                    FirebaseManager.shared.getBossTruck { [weak self] (truckData) in
//                        
//                        guard let data = truckData else {return}
//                        
//                        self?.bossUIView.setupValue(name: data.name, story: data.story)
//                    }
//                    
//                    bossUIView.addTruckBtn.isHidden = true
//                    return
//            }
//            bossUIView.addTruckBtn.isHidden = false
//        }
//    }
//    
//    @objc func clickEditBtn() {
//        
//        print("edit")
//    }
//    
//    @objc func clickAddBtn() {
//        
//        guard let rootVC = AppDelegate.shared.window?.rootViewController
//            as? TabBarViewController else { return }
//        rootVC.tabBar.isHidden = true
//        
//        guard let editVC = UIStoryboard.profile.instantiateViewController(
//            withIdentifier: "modifyVC") as? AddBossTruckViewController else {return}
//        
//        bossUIView.cleanValue()
//        editVC.modalPresentationStyle = .overCurrentContext
//        present(editVC, animated: false, completion: nil)
//    }

}
