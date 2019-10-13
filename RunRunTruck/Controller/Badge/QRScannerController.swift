//
//  QRScannerController.swift
//  RunRunTruck
//
//  Created by yueh on 2019/9/17.
//  Copyright © 2019 yueh. All rights reserved.
//

import UIKit
import AVFoundation

protocol QRScannerControllerDelegate: AnyObject {
    
    func didFinishScanner(truckId: String)
}

class QRScannerController: UIViewController {
    
    var captureSession = AVCaptureSession()
    var videoPreviewLayer: AVCaptureVideoPreviewLayer?
    var qrCodeFrameView: UIView?
    
    weak var delegate: QRScannerControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationController?.navigationBar.barTintColor = .black
        
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(
            image: UIImage.asset(.Icon_whiteBack),
            style: .plain,
            target: self,
            action: #selector(back))
        
        let deviceDiscoverySession = AVCaptureDevice.DiscoverySession(
            deviceTypes: [.builtInDualCamera],
            mediaType: AVMediaType.video, position: .back)
        
        guard let captureDevice = deviceDiscoverySession.devices.first else {return }
        
        do {
            // 使用前一個裝置物件來取得 AVCaptureDeviceInput 類別的實例
            let input = try AVCaptureDeviceInput(device: captureDevice)
            
            // 在擷取 session 設定輸入裝置
            captureSession.addInput(input)
            
            let captureMetadataOutput = AVCaptureMetadataOutput()
            captureSession.addOutput(captureMetadataOutput)
            
            captureMetadataOutput.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
            captureMetadataOutput.metadataObjectTypes = [AVMetadataObject.ObjectType.qr]
            
            // 初始化影片預覽層，並將其作為子層加入 viewPreview 視圖的圖層中
            videoPreviewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
            videoPreviewLayer?.videoGravity = AVLayerVideoGravity.resizeAspectFill
            videoPreviewLayer?.frame = view.layer.bounds
            view.layer.addSublayer(videoPreviewLayer!)
            
            captureSession.startRunning()
            
            qrCodeFrameView = UIView()
            
            if let qrCodeFrameView = qrCodeFrameView {
                qrCodeFrameView.layer.borderColor = UIColor.blue.cgColor
                qrCodeFrameView.layer.borderWidth = 2
                view.addSubview(qrCodeFrameView)
                view.bringSubviewToFront(qrCodeFrameView)
            }
            
        } catch {return }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        let handleSettingAlert = HandleSettingAlert()
        
        switch AVCaptureDevice.authorizationStatus(for: .video) {
            
        case .denied, .restricted:
            
            let alertVc = handleSettingAlert.openSetting(title: "未開啟相機權限",
                                                         msg: "沒有開啟相機權限無法掃描喔！",
                                                         settingTitle: "去設定",
                                                         cancelTitle: "我知道了",
                                                         vc: self)
            
            present(alertVc, animated: true, completion: nil)
            
        default:
            break
        }
        self.navigationController?.tabBarController?.tabBar.isHidden = true
    }

    @objc func back() {
        navigationController?.popViewController(animated: true)
        
    }
    // MARK: - 狀態列的顯示
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
}

extension QRScannerController: AVCaptureMetadataOutputObjectsDelegate {
    
    func metadataOutput(_ output: AVCaptureMetadataOutput,
                        didOutput metadataObjects: [AVMetadataObject],
                        from connection: AVCaptureConnection) {
        
        if metadataObjects.count == 0 {
            qrCodeFrameView?.frame = CGRect.zero
           return
        }
        
        // 取得元資料（metadata）物件
        guard let metadataObj = metadataObjects[0] as? AVMetadataMachineReadableCodeObject else {return}
        
        if metadataObj.type == AVMetadataObject.ObjectType.qr {
            
            // 倘若發現的元資料與 QR code 元資料相同，便更新狀態標籤的文字並設定邊界
            let barCodeObject = videoPreviewLayer?.transformedMetadataObject(for: metadataObj)
            qrCodeFrameView?.frame = barCodeObject!.bounds
            
            if let truckId = metadataObj.stringValue {
               
                guard
                    let currentUser = FirebaseManager.shared.currentUser,
                    let type = currentUser.type else { return }
                
                switch type {
                case .boss :
                    FirebaseManager.shared.updateArrayData(type: User.boss.rawValue,
                                                           id: currentUser.uid,
                                                           key: User.badge.rawValue,
                                                           value: truckId, completion: nil)
                case .normalUser:
                     FirebaseManager.shared.updateArrayData(type: User.user.rawValue,
                                                            id: currentUser.uid,
                                                            key: User.badge.rawValue,
                                                            value: truckId, completion: nil)
                }
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5, execute: { [weak self] in
                    
                    self?.navigationController?.popViewController(animated: true)
                    self?.delegate?.didFinishScanner(truckId: truckId)
                })
            }
        }
    }
}
