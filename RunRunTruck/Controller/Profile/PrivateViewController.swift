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
    @IBOutlet weak var backBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        showInfo()
        setLayout()
        privateWebView.navigationDelegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        backBtn.addTarget(self, action: #selector(backToRoot), for: .touchUpInside)
        navigationController?.setNavigationBarHidden(true, animated: false)
      
        if let tabbarVc = self.navigationController?.tabBarController {
            tabbarVc.tabBar.isHidden = true
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(false, animated: animated)
        super.viewWillDisappear(animated)
    }
    
    func setLayout() {
        backBtn.layer.cornerRadius = backBtn.frame.width / 2
        backBtn.clipsToBounds = true
    }
    
    func showInfo() {
        
        let link = "https://www.privacypolicies.com/privacy/view/c082ee6447f9e7283c678be24b07d477"
        
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
