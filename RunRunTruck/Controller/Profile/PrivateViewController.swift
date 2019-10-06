//
//  PrivateViewController.swift
//  RunRunTruck
//
//  Created by yueh on 2019/9/24.
//  Copyright © 2019 yueh. All rights reserved.
//

import UIKit
import WebKit

class PrivateViewController: UIViewController {
    
    @IBOutlet weak var privateWebView: WKWebView!
    @IBOutlet weak var activityIndicatorView: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        showInfo()
        privateWebView.navigationDelegate = self

        navigationItem.leftBarButtonItem = UIBarButtonItem(
                   image: UIImage.asset(.Icon_back),
                   style: .plain,
                   target: self,
                   action: #selector(backToRoot))
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.isNavigationBarHidden = false
        if let tabBarVc = self.navigationController?.tabBarController {
            tabBarVc.tabBar.isHidden = true
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }

    func showInfo() {
        
        let link = Bundle.ValueForString(key: Constant.privateLink)
        
        if let url = URL(string: link) {
            let request = URLRequest(url: url)
            privateWebView.load(request)
        }
    }
    
    @objc func backToRoot() {
        
        navigationController?.popViewController(animated: true)
    }
}

extension PrivateViewController: WKNavigationDelegate {
    
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        activityIndicatorView.startAnimating()
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
         DispatchQueue.main.async {
            self.activityIndicatorView.stopAnimating()
            self.activityIndicatorView.hidesWhenStopped = true
           }
    }
}
