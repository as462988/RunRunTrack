//
//  BadgeViewController.swift
//  RunRunTruck
//
//  Created by yueh on 2019/9/17.
//  Copyright © 2019 yueh. All rights reserved.
//

import UIKit

class BadgeViewController: UIViewController {
    
    @IBOutlet weak var scannerBtn: UIButton!
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
    
    var allTrucks: [(TruckData, Bool)] = []
    
    var index: Int?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateDataFromFirebaseManager()
        observerAllTrucksUpdate()
        observerUserUpdated()
        setLayout()
        scannerBtn.addTarget(self, action: #selector(enterScannerButton), for: .touchUpInside)
        self.view.addSubview(getBadgeView)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        print("viewWillAppear")
        
        self.navigationController?.isNavigationBarHidden = false
        self.navigationController?.navigationBar.barTintColor = .white
        self.navigationController?.tabBarController?.tabBar.isHidden = false
    }
    
    func observerAllTrucksUpdate() {
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(updateDataFromFirebaseManager),
                                               name: Notification.Name(FirebaseManager.allTruckDataNotificationName),
                                               object: nil)
    }
    
    func observerUserUpdated() {
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(updateDataFromFirebaseManager),
                                               name: Notification.Name(FirebaseManager.userNotificationName),
                                               object: nil)
    }
    
    func setLayout() {
        scannerBtn.layer.cornerRadius = 10
        scannerBtn.clipsToBounds = true
    }
    
   @objc func updateDataFromFirebaseManager() {
        let user = FirebaseManager.shared.currentUser
        allTrucks = FirebaseManager.shared.allTruckData.map({ (truck) -> (TruckData, Bool) in
            return (truck, user != nil ? user!.badge.contains(truck.id) : false)
        })
        self.badgeCollectionView.reloadData()
    }
    
    @objc func enterScannerButton(sender: UIButton) {
       guard FirebaseManager.shared.bossID != nil || FirebaseManager.shared.userID != nil  else {

        ProgressHUD.showFailure(text: "登入會員就可以蒐藏徽章囉！")

            return
        }
        
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
        return allTrucks.count
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let truckDataWithBadgeIsAchieved = allTrucks[indexPath.item]
        guard let badgeCell = collectionView.dequeueReusableCell(
            withReuseIdentifier: "badgeCell", for: indexPath) as? BadgeCollectionViewCell else {
            return UICollectionViewCell()
        }
        
        badgeCell.setValue(logo: truckDataWithBadgeIsAchieved.0.logoImage, name: truckDataWithBadgeIsAchieved.0.name)
        
        badgeCell.changeLayout(alpha: truckDataWithBadgeIsAchieved.1 ? 1 : 0.2)
        
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

        if let index = self.allTrucks.firstIndex(where: { (data) -> Bool in
            return data.0.id == truckId
        }) {
            getBadgeView.setImage(imageUrl: allTrucks[index].0.logoImage)
            getBadgeView.animateAppear()
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
            
            self.getBadgeView.isHidden = true
        }
    }
}
