//
//  AddBossTruckViewController.swift
//  RunRunTruck
//
//  Created by yueh on 2019/9/10.
//  Copyright © 2019 yueh. All rights reserved.
//

import UIKit

class AddBossTruckViewController: UIViewController {
    
    @IBOutlet weak var truckTextInput: UITextView!
    @IBOutlet weak var showLogoImage: UIImageView!
     @IBOutlet weak var clickSendBtn: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()

        setLayout()

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

    }
    
    func setLayout() {
        
        clickSendBtn.layer.cornerRadius = 20
        clickSendBtn.layer.masksToBounds = true
        
        showLogoImage.layer.cornerRadius = 20
        showLogoImage.layer.masksToBounds = true
    }
    
    @IBAction func upLoadImageBtn(_ sender: Any) {
        
    }
    
    @IBAction func clickSendBtn(_ sender: Any) {
        
        guard let inputText = truckTextInput.text else { return}
        
        guard inputText.isEmpty == false else {
            print("請跟我們分享你的故事")
            return
        }
        
        let name = FirebaseManager.shared.currentUser?.name
        
        FirebaseManager.shared.addTurck(name: name!,
                                        img: "https://firebasestorage.googleapis.com/v0/b/runruntruck.appspot.com/o/images.png?alt=media&token=0dce6bc9-31e8-4d2f-ad04-7ee90cba2654",
                                        story: inputText) { [weak self] (truckID) in
            
             FirebaseManager.shared.addTurckIDInBoss(truckId: truckID)
            
            DispatchQueue.main.async {
                guard let rootVC = AppDelegate.shared.window?.rootViewController
                    as? TabBarViewController else { return }
                rootVC.tabBar.isHidden = false
                let vc = self?.presentingViewController
                self?.dismiss(animated: false) {
                    vc?.dismiss(animated: false, completion: nil)
                }
            }
        }
    }
    @IBAction func clickCancelBtn(_ sender: Any) {
        
        print("不給你點！～")
//        guard let rootVC = AppDelegate.shared.window?.rootViewController
//            as? TabBarViewController else { return }
//        rootVC.tabBar.isHidden = false
//
//
//        let vc = presentingViewController
//        dismiss(animated: false) {
//            vc?.dismiss(animated: false, completion: nil)
//        }
    }
}
