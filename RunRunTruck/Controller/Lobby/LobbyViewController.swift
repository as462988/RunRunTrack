//
//  ViewController.swift
//  RunRunTruck
//
//  Created by yueh on 2019/8/27.
//  Copyright © 2019 yueh. All rights reserved.
//

import UIKit
import GoogleMaps
import CoreLocation
import Crashlytics

class LobbyViewController: UIViewController {
    
    @IBOutlet weak var lobbyView: LobbyView! {
        
        didSet {
            
            lobbyView.delegate = self
        }
    }
    
    let addressManager = AddressManager()
    
    let handleOpenURL = HandleOpenURL()
    
    let handleSettingAlert = HandleSettingAlert()
    
    var centerLat = 25.027758
    
    var centeyLon = 121.550017
    
    override func viewDidLoad() {
        super.viewDidLoad()

        lobbyView.setMapView(lat: centerLat, lon: centeyLon, zoom: 15)
        
        //拿取所有營業中的餐車顯示在地圖
        FirebaseManager.shared.getOpeningTruckData(isOpen: true) {[weak self] (truckDatas) in
            if let truckDatas = truckDatas {
                let dispatchGroup = DispatchGroup()
                for var truckData in truckDatas {

                    switch truckData.1 {
                    case .added:
                        //新增
                        dispatchGroup.enter()
                        self?.lobbyView.addMarker(
                            lat: truckData.0.location!.latitude,
                            long: truckData.0.location!.longitude,
                            imageUrl: truckData.0.logoImage)

                        self?.addressManager.getLocationAddress(
                            lat: truckData.0.location!.latitude,
                            long: truckData.0.location!.longitude,
                            completion: {(location, error) in

                                guard let location = location else {return}

                                let address = location.subAdministrativeArea
                                    + location.city + location.street

                                truckData.0.address = address
                                FirebaseManager.shared.openIngTruckData.append(truckData.0)
                                dispatchGroup.leave()

                        })

                    case .removed:
                        //刪除
                        dispatchGroup.enter()
                        if let markerIndex = self?.lobbyView.markers.firstIndex(where: { (marker) -> Bool in
                            return marker.position.longitude == truckData.0.location?.longitude
                        }) {
                            self?.lobbyView.markers[markerIndex].map = nil
                            self?.lobbyView.markers.remove(at: markerIndex)
                        }

                        if let index = FirebaseManager.shared.openIngTruckData.firstIndex(
                            where: { (truckdata) -> Bool in
                                return truckdata.id == truckData.0.id
                        }) {
                            FirebaseManager.shared.openIngTruckData.remove(at: index)
                            dispatchGroup.leave()
                        }
                    case .modified: break
                    @unknown default:
                            fatalError()
                    }

                }
                dispatchGroup.notify(queue: .main, execute: {
                    self?.lobbyView.reloadData()
                })
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.isNavigationBarHidden = true
    }
}

extension LobbyViewController: LobbyViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return FirebaseManager.shared.openIngTruckData.count
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: String(describing: TurckInfoCollectionViewCell.self),
            for: indexPath) as? TurckInfoCollectionViewCell else {
                return UICollectionViewCell()
        }
        
        let data = FirebaseManager.shared.openIngTruckData[indexPath.row]
        
        cell.delegate = self
        cell.configureWithTruckData(truckData: data)
        cell.setValue(name: data.name,
                      openTime: data.openTime!,
                      logoImage: data.logoImage,
                      truckLocationText: data.address)
        
        cell.latitude = data.location!.latitude
        cell.longitude = data.location!.longitude
        cell.layer.cornerRadius = 20
        cell.clipsToBounds = true
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        return false
    }

    // MARK: - 滑動 collectionView (paging)
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        self.checkPage()
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            if !self.lobbyView.truckCollectionView.isDecelerating {
                self.checkPage()
            }
        }
    }
    
    func checkPage() {
        let page = lobbyView.truckCollectionView.contentOffset.x / LobbyView.cardItemSize.width
        
        let roundPage = round(page)
        
        var targetIndex = 0
        
        if page - 0.5 >= roundPage {
            targetIndex = Int(roundPage) + 1
        } else {
            targetIndex = roundPage == 0 || roundPage == -1 ? 0 : Int(roundPage)
        }
        
        lobbyView.truckCollectionView.scrollToItem(at: IndexPath(row: targetIndex, section: 0),
                                                   at: .centeredHorizontally,
                                                   animated: true)
        
        let location = FirebaseManager.shared.openIngTruckData[targetIndex].location
        
        lobbyView.updataMapView(lat: location!.latitude, long: location!.longitude, zoom: 15)
    }
    
    // MARK: - GoogleMap
    // 點擊 marker
    func mapView(_ mapView: GMSMapView, didTap marker: GMSMarker) -> Bool {
        
        self.reloadLobbyViewWithChangeLocation(lat: marker.position.latitude, lon: marker.position.longitude, zoom: 15)
        
        return true
    }
    
    func reloadLobbyViewWithChangeLocation(lat: Double, lon: Double, zoom: Float) {
        
        var indexNum = Int()
        
        for (index, data) in FirebaseManager.shared.openIngTruckData.enumerated() where
            
            lat == data.location!.latitude {
                
                indexNum = index
        }
        
        self.lobbyView.truckCollectionView.scrollToItem(
            at: IndexPath(row: indexNum, section: 0),
            at: .centeredHorizontally,
            animated: true
        )
        
        self.lobbyView.updataMapView(lat: lat, long: lon, zoom: zoom)
        
    }
    
    //點擊 MyLocationButton
    func didTapMyLocationButton(for mapView: GMSMapView) -> Bool {
        
        lobbyView.locationManager.requestWhenInUseAuthorization()
        
        if let myLocation = lobbyView.locationManager.location {

            self.lobbyView.updataMapView(lat: myLocation.coordinate.latitude,
                                         long: myLocation.coordinate.longitude,
                                         zoom: 15)
            
        } else {

            let alertVc = handleSettingAlert.openSetting(title: "無法定位",
                                                    msg: "沒有開啟定位系統無法定位喔！",
                                                    settingTitle: "去設定",
                                                    cancelTitle: "我知道了")
            
            present(alertVc, animated: true, completion: nil)
        }
        return true
    }
    
}

extension LobbyViewController: TurckInfoCellDelegate {
    
    func truckInfoCell(truckInfoCell: TurckInfoCollectionViewCell, didNavigateTo location: GeoLocation) {
        
        handleOpenURL.openUrl(lat: location.lat, lon: location.lon, zoom: 10)
        
    }
    
    func truckInfoCell(truckInfoCell: TurckInfoCollectionViewCell,
                       didEnterTruckChatRoom truckData: TruckData) {
        
        guard FirebaseManager.shared.userID == nil && FirebaseManager.shared.bossID == nil else {

            let chatroomVC = ChatroomViewController()
            
            chatroomVC.truckData = truckData
            
            FirebaseManager.shared.getTruckId(truckName: truckData.name)
            
            navigationController?.isNavigationBarHidden = false
            navigationController?.pushViewController(chatroomVC, animated: true)
            return
        }
        
        guard let auth = UIStoryboard.auth.instantiateInitialViewController() else {return}

        guard let rootVC = AppDelegate.shared.window?.rootViewController as? TabBarViewController else { return }
        rootVC.tabBar.isHidden = true
        auth.modalPresentationStyle = .overCurrentContext
        present(auth, animated: false, completion: nil)
        
    }
    func truckInfoCell(truckInfoCell: TurckInfoCollectionViewCell, didEnterTruckInfo truckData: TruckData) {
        
        self.hidesBottomBarWhenPushed = true
        
        guard let truckVC = UIStoryboard.truck.instantiateViewController(
            withIdentifier: String(describing: TruckDetailViewController.self)) as? TruckDetailViewController
            else {return}
        
        truckVC.detailInfo = truckData
        
        navigationController?.isNavigationBarHidden = true
        navigationController?.pushViewController(truckVC, animated: true)
        self.hidesBottomBarWhenPushed = false

    }
    
}
