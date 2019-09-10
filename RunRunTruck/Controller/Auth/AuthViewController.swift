//
//  AuthViewController.swift
//  RunRunTruck
//
//  Created by yueh on 2019/9/2.
//  Copyright © 2019 yueh. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import Lottie

class AuthViewController: UIViewController {
    
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var loginSegment: UISegmentedControl!
    @IBOutlet weak var singInBtn: UIButton!
    @IBOutlet weak var pswTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    
    @IBOutlet weak var animationView: AnimationView!
    
    var userLoginIsFinished = false {
        didSet {
            updateRegisteBtnStatus()
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        pswTextField.delegate = self
        emailTextField.delegate = self
        contentView.layer.cornerRadius = 10
        contentView.clipsToBounds = true
        singInBtn.layer.cornerRadius = 10
        singInBtn.clipsToBounds = true
        loginSegment.addTarget(self, action: #selector(handleLoginChange), for: .valueChanged)
        singInBtn.addTarget(self, action: #selector(handleLogin), for: .touchUpInside)
        checkUserInput()

    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        playAnimation()
    }
    
    func playAnimation() {
        
        animationView.animation = Animation.named("lf30_editor_envOAW")
        animationView.loopMode = .loop
        animationView.play()
    }
    
    @IBAction func dismissView(_ sender: Any) {
        
        guard let rootVC = AppDelegate.shared.window?.rootViewController as? TabBarViewController else { return }
        rootVC.tabBar.isHidden = false
         presentingViewController?.dismiss(animated: false, completion: nil)
    }
    
    @IBAction func signUpPage(_ sender: Any) {
        
        guard let authVC =
            UIStoryboard.auth.instantiateViewController(withIdentifier: "SignUpPage")
                as? AuthSignUpViewController else { return }
        
        authVC.modalPresentationStyle = .overCurrentContext
        present(authVC, animated: false, completion: nil)

    }
    
    @objc func handleLogin() {
        
        if loginSegment.selectedSegmentIndex == 0 {
             handleUserLogin()
        } else {
            handleBossLogin()
        }
    }
    
    func handleUserLogin() {
        
        guard let email = emailTextField.text,
            let psw = pswTextField.text else { return }
        
        FirebaseManager.shared.singInWithEmail(email: email, psw: psw) { [weak self] in
            
            FirebaseManager.shared.getCurrentUserData(completion: { (data) in
                
                self?.presentingViewController?.dismiss(animated: false, completion: nil)
                
                guard let rootVC = AppDelegate.shared.window?.rootViewController as? TabBarViewController else { return }
                rootVC.tabBar.isHidden = false
                
            })
        }
    }
    
    func handleBossLogin() {
        print("Boss")
    }
    
    @objc func handleLoginChange() {
        
        let title = loginSegment.titleForSegment(at: loginSegment.selectedSegmentIndex)
        singInBtn.setTitle(title, for: .normal)
        emailTextField.text = ""
        pswTextField.text = ""
    }
}

extension AuthViewController: UITextFieldDelegate {
    
    func checkUserInput() {
        
        guard let email = emailTextField.text,
            let psw = pswTextField.text else { return }
        
        if email.isEmpty, psw.isEmpty {
            
            userLoginIsFinished = false
            
        } else {

            userLoginIsFinished = true
        }
    }
    
    func updateRegisteBtnStatus() {
        
        setBtnStatus(userLoginIsFinished ? .enable: .disable, btn: singInBtn)
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        
        checkUserInput()
    }
}
