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
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        guard let rootVC = AppDelegate.shared.window?.rootViewController
            as? TabBarViewController else { return }
        rootVC.tabBar.isHidden = false
    }
    
    @IBAction func animateButton(sender: UIButton) {
        
        sender.transform = CGAffineTransform(scaleX: 0.6, y: 0.6)
        
        UIView.animate(withDuration: 2.0,
                       delay: 0,
                       usingSpringWithDamping: CGFloat(0.20),
                       initialSpringVelocity: CGFloat(6.0),
                       options: UIView.AnimationOptions.allowUserInteraction,
                       animations: {
                        sender.transform = CGAffineTransform.identity
        },
                       completion: { Void in()  }
        )
        
        guard let rootVC = AppDelegate.shared.window?.rootViewController
            as? TabBarViewController else { return }
        rootVC.tabBar.isHidden = true
        
        let vc = UIStoryboard.badge.instantiateViewController(withIdentifier: "scannerVC")
        show(vc, sender: nil)

    }

}
