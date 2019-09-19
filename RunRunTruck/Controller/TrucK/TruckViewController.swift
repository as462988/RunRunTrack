//
//  TruckViewController.swift
//  RunRunTruck
//
//  Created by yueh on 2019/9/19.
//  Copyright © 2019 yueh. All rights reserved.
//

import UIKit

class TruckViewController: UIViewController {
    
    @IBOutlet weak var truckCollectionView: UICollectionView!
    
    var allTruckArr = [TruckData]()

    override func viewDidLoad() {
        super.viewDidLoad()


    }
    
    

}

extension TruckViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 5
//        return allTruckArr.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let truckCell = collectionView.dequeueReusableCell(
            withReuseIdentifier: "truckCell", for: indexPath) as? TrcukCollectionViewCell else {
                return UICollectionViewCell()
        }
        
        return truckCell
    }
    
    
    
    
}
