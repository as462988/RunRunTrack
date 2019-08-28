//
//  LobbyView.swift
//  RunRunTruck
//
//  Created by yueh on 2019/8/28.
//  Copyright © 2019 yueh. All rights reserved.
//

import UIKit
import GoogleMaps

protocol LobbyViewDelegate: UICollectionViewDelegate, UICollectionViewDataSource, AnyObject {

}

class LobbyView: UIView {

    @IBOutlet weak var truckCollectionView: UICollectionView! {
        
        didSet {
            
            truckCollectionView.dataSource = self.delegate
            
            truckCollectionView.delegate = self.delegate
        }
    }
    
    @IBOutlet weak var mapView: GMSMapView!
    
    weak var delegate: LobbyViewDelegate? {
        
        didSet {
            
            guard let truckCollectionView = truckCollectionView else { return }
            
            truckCollectionView.dataSource = self.delegate
            
            truckCollectionView.delegate = self.delegate
        }
    }
    
    lazy var cardLayout: TruckInfoCollectionViewLayout = {
        let layout = TruckInfoCollectionViewLayout()
        layout.itemSize = CGSize(width: 200, height: 130)
        return layout
    }()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setCollectionView()
    }
    
    func reloadData() {

        truckCollectionView.reloadData()
    }
    
    private func setCollectionView() {
        truckCollectionView.showsHorizontalScrollIndicator = false
        truckCollectionView.collectionViewLayout = cardLayout
    }
}
