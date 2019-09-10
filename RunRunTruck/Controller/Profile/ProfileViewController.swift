//
//  TruckListViewController.swift
//  RunRunTruck
//
//  Created by yueh on 2019/8/30.
//  Copyright © 2019 yueh. All rights reserved.
//

import UIKit

class ProfileViewController: UIViewController {
    
    @IBOutlet weak var bossUIView: BossUIView!
    @IBOutlet weak var userUIView: UserUIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        bossUIView.editBtn.addTarget(self, action: #selector(clickEditBtn), for: .touchUpInside)
        
        bossUIView.addTruckBtn.addTarget(self, action: #selector(clickAddBtn), for: .touchUpInside)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if FirebaseManager.shared.bossID == nil {
            userUIView.isHidden = false
            bossUIView.isHidden = true
        } else {
            userUIView.isHidden = true
            bossUIView.isHidden = false
            
            guard FirebaseManager.shared.currentUser?.truckId == nil || FirebaseManager.shared.currentUser?.truckId == ""
                else {
                    bossUIView.addTruckBtn.isHidden = true
                    return
            }
            bossUIView.addTruckBtn.isHidden = false
        }
    }
    
    @objc func clickEditBtn() {
        
        print("edit")
    }
    
    @objc func clickAddBtn() {
        
        guard let rootVC = AppDelegate.shared.window?.rootViewController
            as? TabBarViewController else { return }
        rootVC.tabBar.isHidden = true
        
        guard let editVC = UIStoryboard.profile.instantiateViewController(
            withIdentifier: "modifyVC") as? AddBossTruckViewController else {return}
        
        editVC.modalPresentationStyle = .overCurrentContext
        present(editVC, animated: false, completion: nil)
    }

}
