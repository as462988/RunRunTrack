//
//  UIStoryboard+Extension.swift
//  RunRunTruck
//
//  Created by yueh on 2019/8/27.
//  Copyright © 2019 yueh. All rights reserved.
//

import UIKit

private struct StoryboardCategory {
    
    static let main = "Main"
    
    static let lobby = "Lobby"
    
    static let truck = "Truck"
    
    static let badge = "Badge"
    
    static let profile = "Profile"
    
}

extension UIStoryboard {
    
    static var main: UIStoryboard { return stStoryboard(name: StoryboardCategory.main) }
    
    static var lobby: UIStoryboard { return stStoryboard(name: StoryboardCategory.lobby) }
    
    static var truck: UIStoryboard { return stStoryboard(name: StoryboardCategory.truck) }
    
    static var badge: UIStoryboard { return stStoryboard(name: StoryboardCategory.badge) }
    
    static var profile: UIStoryboard { return stStoryboard(name: StoryboardCategory.profile) }
    
    private static func stStoryboard(name: String) -> UIStoryboard {
        
        return UIStoryboard(name: name, bundle: nil)
    }
}
