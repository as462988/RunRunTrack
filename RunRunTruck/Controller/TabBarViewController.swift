//
//  TabBarViewController.swift
//  RunRunTruck
//
//  Created by yueh on 2019/8/27.
//  Copyright © 2019 yueh. All rights reserved.
//

import UIKit

private enum Tab {
    
    case lobby
    
    case profile
    
    case truck
    
    case badge
    
    func  controller() -> UIViewController {
        var controller: UIViewController
        
        switch self {
        case .lobby:
            controller = UIStoryboard.lobby.instantiateInitialViewController()!
        case .profile:
            controller = UIStoryboard.profile.instantiateInitialViewController()!
        case .truck:
            controller = UIStoryboard.truck.instantiateInitialViewController()!
        case .badge:
            controller = UIStoryboard.badge.instantiateInitialViewController()!
        }
        
        controller.tabBarItem = tabBarItem()
        
        controller.tabBarItem.imageInsets = UIEdgeInsets(top: 4.0, left: 0.0, bottom: -4.0, right: 0.0)
        
        return controller
    }
    func tabBarItem() -> UITabBarItem {
        
        switch self {
            
        case .lobby:
            return UITabBarItem(
                title: nil,
                image: UIImage.asset(.Icon_default),
                selectedImage: UIImage.asset(.Icon_default)
            )
            
        case .truck:
            return UITabBarItem(
                title: nil,
                image: UIImage.asset(.Icon_car),
                selectedImage: UIImage.asset(.Icon_car)
            )
            
        case .badge:
            return UITabBarItem(
                title: nil,
                image: UIImage.asset(.Icon_brdge),
                selectedImage: UIImage.asset(.Icon_brdge)
            )
            
        case .profile:
            return UITabBarItem(
                title: nil,
                image: UIImage.asset(.Icon_profile),
                selectedImage: UIImage.asset(.Icon_profile)
            )
        }
    }
}

class TabBarViewController: UITabBarController {

    private let tabs: [Tab] = [.lobby, .truck, .badge, .profile]
    
    override func viewDidLoad() {
        super.viewDidLoad()

        viewControllers = tabs.map({ $0.controller()})
    }
}
