//
//  ViewController.swift
//  RunRunTruck
//
//  Created by yueh on 2019/8/27.
//  Copyright © 2019 yueh. All rights reserved.
//

import UIKit

class LobbyViewController: UIViewController {

    @IBOutlet weak var lobbyView: LobbyView! {
        
        didSet {
            
            lobbyView.delegate = self
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    navigationController?.isNavigationBarHidden = true
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        FirebaseManager.shared.getTruckData { (data) in
            print(data?[0].name ?? "name")
            print(data?[0].openTime.dateValue() ?? Data.self)
            
            DispatchQueue.main.async {
                 self.lobbyView.reloadData()
            }
        }
    }
}

extension LobbyViewController: LobbyViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return FirebaseManager.shared.truckData.count
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: "truckInfoCell", for: indexPath) as? TurckInfoCollectionViewCell else {
            return UICollectionViewCell()
        }
        
        let data = FirebaseManager.shared.truckData[indexPath.row]
        
        let openTime = FirebaseManager.dateConvertString(
            date: data.openTime.dateValue())
        
        let colseTime = FirebaseManager.dateConvertString(
            date: data.closeTime.dateValue())
        
        cell.setValue(name: data.name, openTime: openTime, closeTime: colseTime, logoImage: data.logoImage)

        return cell
    }
}
