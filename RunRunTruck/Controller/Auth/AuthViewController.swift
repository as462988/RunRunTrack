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

class AuthViewController: UIViewController {
    
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var loginSegment: UISegmentedControl!
    @IBOutlet weak var singInBtn: UIButton!
    @IBOutlet weak var pswTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    
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
    
    @IBAction func dismissView(_ sender: Any) {
        
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
            
            self?.presentingViewController?.dismiss(animated: false, completion: nil)
            FirebaseManager.shared.getCurrentUserData(completion: { (data) in
                
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
    
//    func textFieldDidEndEditing(_ textField: UITextField) {
//
//        guard let email = emailTextField.text, let psw = pswTextField.text else {
//            singInBtn.isEnabled = false
//            singInBtn.alpha = 0.5
//            return
//        }
//        if !email.isEmpty && !psw.isEmpty {
//            singInBtn.isEnabled = true
//            singInBtn.alpha = 1
//        } else {
//            singInBtn.isEnabled = false
//            singInBtn.alpha = 0.5
//        }
//    }
    
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
