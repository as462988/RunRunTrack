//
//  ViewController.swift
//  RunRunTruck
//
//  Created by yueh on 2019/8/27.
//  Copyright © 2019 yueh. All rights reserved.
//

import UIKit
//import GoogleMaps

class LobbyViewController: UIViewController {

//     @IBOutlet weak var googleMapView: GMSMapView!
    
    var lobbyView = LobbyView()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    self.view.addSubview(lobbyView)
        navigationController?.isNavigationBarHidden = true
        setLobbyView()
    }
    
    func setLobbyView() {
        
        lobbyView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            lobbyView.topAnchor.constraint(equalTo: self.view.topAnchor),
            lobbyView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor),
            lobbyView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
            lobbyView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor)
            ])
        
    }
}
