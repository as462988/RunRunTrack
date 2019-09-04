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
    
    @IBOutlet weak var singInBtn: UIButton!
    @IBOutlet weak var pswTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        pswTextField.delegate = self
        emailTextField.delegate = self
        contentView.layer.cornerRadius = 10
        contentView.clipsToBounds = true

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
    
    @IBAction func clickSingInBtn(_ sender: Any) {
        
        guard let email = emailTextField.text,
            let psw = pswTextField.text else { return }
        
        FirebaseManager.shared.singInWithEmail(email: email, psw: psw) { [weak self] in
            
            self?.presentingViewController?.dismiss(animated: false, completion: nil)
            FirebaseManager.shared.getCurrentUserData(completion: { (data) in
                print(data?.name)
            })
            
        }
    }
}

extension AuthViewController: UITextFieldDelegate {
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        
        guard let email = emailTextField.text, let psw = pswTextField.text else {
            singInBtn.isEnabled = false
            singInBtn.alpha = 0.5
            return
        }
        if !email.isEmpty && !psw.isEmpty {
            singInBtn.isEnabled = true
            singInBtn.alpha = 1
        } else {
            singInBtn.isEnabled = false
            singInBtn.alpha = 0.5
        }
    }
}
