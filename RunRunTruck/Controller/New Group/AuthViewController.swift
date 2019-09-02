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
    
    @IBOutlet weak var loginBTN: UIButton!
    @IBOutlet weak var pswTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!

    override func viewDidLoad() {
        super.viewDidLoad()
        
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
    
    @IBAction func signIn(_ sender: Any) {
        
        guard let email = emailTextField.text,
            let psw = pswTextField.text else { return }
        
        FirebaseManager.shared.singInWithEmail(email: email, psw: psw) {
            
            self.presentingViewController?.dismiss(animated: false, completion: nil)
        }
    }
}
