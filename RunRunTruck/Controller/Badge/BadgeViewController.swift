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
    
    let getBadgeView: GetBadgeView = {
       let view = GetBadgeView()
        view.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
        view.isHidden = true
        return view
    }()
    
    var badgeArr: [TruckBadge] = []
    
    var index: Int?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        FirebaseManager.shared.getAllTruckData { [weak self] (truckDatas) in
            guard let truckDatas = truckDatas else { return }
            
            for truckData in truckDatas {
                
                self?.badgeArr.append(truckData)
            }
            
            self?.getUserBadgeisAchieved()
            
            DispatchQueue.main.async {
                self?.badgeCollectionView.reloadData()
            }
        }
        
        self.view.addSubview(getBadgeView)

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        getUserBadgeisAchieved()

    }
    
    func getUserBadgeisAchieved() {
        
        guard let user = FirebaseManager.shared.currentUser else {
            return
        }
        
        for (index, userData) in badgeArr.enumerated() {
            
            if user.badge.contains(userData.truckId) {
                
                badgeArr[index].isAchieved = true
            }
        }
        
        self.badgeCollectionView.reloadData()
    }
    
    @IBAction func animateButton(sender: UIButton) {
       guard FirebaseManager.shared.bossID != nil || FirebaseManager.shared.userID != nil  else {
        
            print("請先登入會員")
        
            return
        }
        
        guard let rootVC = AppDelegate.shared.window?.rootViewController
            as? TabBarViewController else { return }
        rootVC.tabBar.isHidden = true
        
       guard let scannerVC = UIStoryboard.badge.instantiateViewController(
        withIdentifier: "scannerVC") as? QRScannerController else {return}
        
        scannerVC.delegate = self
        
        show(scannerVC, sender: nil)
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

extension BadgeViewController: QRScannerControllerDelegate {
    
    func didFinishScanner(truckId: String) {
        
        self.navigationController?.isNavigationBarHidden = true
        
        getBadgeView.isHidden = false
        getBadgeView.backgroundColor = .clear

        if let index = self.badgeArr.firstIndex(where: { (data) -> Bool in
            return data.truckId == truckId
        }) {
            getBadgeView.setImage(imageUrl: badgeArr[index].logoImage)
            getBadgeView.animateAppear()
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
            
            self.navigationController?.isNavigationBarHidden = false
            self.navigationController?.navigationBar.barTintColor = .white
            guard let rootVC = AppDelegate.shared.window?.rootViewController
                as? TabBarViewController else { return }
            rootVC.tabBar.isHidden = false
            self.getBadgeView.isHidden = true
        }
    }
}
