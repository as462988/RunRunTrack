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
    
    @IBOutlet weak var segmentRegister: UISegmentedControl!
    @IBOutlet weak var contentView: UIView!
    
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var pswTextField: UITextField!
    @IBOutlet weak var pswConfirmTextField: UITextField!
    @IBOutlet weak var registerBtn: UIButton!
    
    var userRegisteIsFinished = false {
        didSet {
            updateRegisteBtnStatus()
        }
    }
    
    var isNameAvailable = false
    var isEmailAvailable = false
    var isPswAvailable = false
    var isPswConfirmAvailable = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        nameTextField.delegate = self
        emailTextField.delegate = self
        pswTextField.delegate = self
        pswConfirmTextField.delegate = self
        
        contentView.layer.cornerRadius = 10
        contentView.clipsToBounds = true
        
        registerBtn.layer.cornerRadius = 10
        registerBtn.clipsToBounds = true
        
        registerBtn.addTarget(self, action: #selector(handleRegisterBtn), for: .touchUpInside)
        
        segmentRegister.addTarget(self, action: #selector(handleRegisterChange), for: .valueChanged)
        
        checkUserInput()
    }
    
    @IBAction func dismissView(_ sender: Any) {
        
        presentingViewController?.dismiss(animated: false, completion: nil)
    }
    
    @objc func handleRegisterBtn() {
        
        if segmentRegister.selectedSegmentIndex == 0 {
            handleUserRegister()
        } else {
            handleBossRegister()
        }

    }
    
    func handleUserRegister() {
        
        guard let name = nameTextField.text,
            let email = emailTextField.text,
            let psw = pswTextField.text else { return }
        
        FirebaseManager.shared.singUpWithEmail(email: email, psw: psw) {
            
            self.presentingViewController?.dismiss(animated: false, completion: nil)
            FirebaseManager.shared.setUserData(name: name, email: email)
        }
    }
    
    func handleBossRegister() {
        print("Boss Register")
    }
    
    @objc func handleRegisterChange() {
        
        let title = segmentRegister.titleForSegment(at: segmentRegister.selectedSegmentIndex)
        registerBtn.setTitle(title, for: .normal)
        
        nameTextField.text = ""
        emailTextField.text = ""
        pswTextField.text = ""
        pswConfirmTextField.text = ""
    }

}

extension AuthSignUpViewController: UITextFieldDelegate {
    
//    enum BtnStatus {
//        case enable
//        case disable
//    }
//
//    // MARK: - 設置 Btn 狀態
//    func setBtnStatus(_ status: BtnStatus, btn: UIButton) {
//        switch status {
//        case .enable:
//            btn.isUserInteractionEnabled = true
//            btn.alpha = 1
//        case .disable:
//            btn.isUserInteractionEnabled = false
//            btn.alpha = 0.5
//        }
//    }
    
    func checkUserInput() {
        
        guard let name = nameTextField.text,
            let email = emailTextField.text,
            let psw = pswTextField.text,
            let pswConfirm = pswConfirmTextField.text else { return }
        
        if name.isEmpty, email.isEmpty, psw.isEmpty, pswConfirm.isEmpty {
           
            userRegisteIsFinished = false
            
        } else {
            
            guard pswConfirm.elementsEqual(psw) else {
               
            userRegisteIsFinished = false
                return
            }
            
            userRegisteIsFinished = true
        }
    }
    
    func updateRegisteBtnStatus() {
        
        setBtnStatus(userRegisteIsFinished ? .enable: .disable, btn: registerBtn)
    }

    func textFieldDidEndEditing(_ textField: UITextField) {
        
        checkUserInput()
    }
}
