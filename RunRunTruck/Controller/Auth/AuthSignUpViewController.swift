//
//  AuthSignUpViewController.swift
//  RunRunTruck
//
//  Created by yueh on 2019/9/2.
//  Copyright © 2019 yueh. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth

class AuthSignUpViewController: UIViewController {
    
     @IBOutlet weak var contentView: UIView!
    
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var pswTextField: UITextField!
    @IBOutlet weak var pswConfirmTextField: UITextField!
    
    var isNameAvailable = false
    var isEmailAvailable = false
    var isPswAvailable = false
    var isPswConfirmAvailable = false
    
    @IBOutlet weak var signUpBTN: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        emailTextField.delegate = self
        pswTextField.delegate = self
        pswConfirmTextField.delegate = self
        
        contentView.layer.cornerRadius = 10
        contentView.clipsToBounds = true
        
        setBtnStatus()
    }
    
    @IBAction func dismissView(_ sender: Any) {
        
        presentingViewController?.dismiss(animated: false, completion: nil)
    }
    
    @IBAction func signUpBTN(_ sender: Any) {
        
        guard let name = nameTextField.text,
            let email = emailTextField.text,
            let psw = pswTextField.text else { return }
        
        FirebaseManager.shared.singUpWithEmail(email: email, psw: psw) {
            
                self.presentingViewController?.dismiss(animated: false, completion: nil)
            FirebaseManager.shared.setUserData(name: name, email: email)
            
        }
    }
}

extension AuthSignUpViewController: UITextFieldDelegate {
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        
        switch  textField {
            
        case nameTextField:
            guard let name = nameTextField.text else { return }
            
            if name.isEmpty {
                isNameAvailable = false
            } else {
                isNameAvailable = true
            }
            
        case emailTextField:
            guard let email = emailTextField.text else { return }
            
            if email.isEmpty {
                isEmailAvailable = false
            } else {
                isEmailAvailable = true
            }
            
        case pswTextField:
            guard let psw = pswTextField.text else { return }
            
            if psw.isEmpty {
                isPswAvailable = false
            } else {
                isPswAvailable = true
            }
            
        case pswConfirmTextField:
            guard let psw = pswTextField.text, let pswConfirm = pswConfirmTextField.text  else { return }
            
            if psw.elementsEqual(pswConfirm) {
                isPswConfirmAvailable = true
            } else {
                isPswConfirmAvailable = false
            }
            
        default: break
        }
        
        setBtnStatus()
    }
    
    func setBtnStatus() {
        
        if isNameAvailable && isEmailAvailable && isPswAvailable && isPswConfirmAvailable {
            signUpBTN.isEnabled = true
            signUpBTN.alpha = 1
        } else {
            signUpBTN.isEnabled = false
            signUpBTN.alpha = 0.5
        }
    }
}
