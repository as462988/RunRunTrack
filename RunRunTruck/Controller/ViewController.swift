//
//  ViewController.swift
//  RunRunTruck
//
//  Created by yueh on 2019/8/27.
//  Copyright © 2019 yueh. All rights reserved.
//

import UIKit
import GoogleMaps

class ViewController: UIViewController {

     @IBOutlet weak var googleMapView: GMSMapView!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        let camera = GMSCameraPosition.camera(withLatitude: 23.963, longitude: 120.522, zoom: 12.0)
        googleMapView.camera = camera
    }
}
