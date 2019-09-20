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

private enum LoginVcUIStatus {
    case userLogin, bossLogin
}

class AuthViewController: UIViewController {
    
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var loginSegment: UISegmentedControl!
    @IBOutlet weak var singInBtn: UIButton!
    @IBOutlet weak var pswTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    
    @IBOutlet weak var animationView: AnimationView!
    private var uiStatus: LoginVcUIStatus = .userLogin
    
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
        loginSegment.addTarget(self, action: #selector(handleUIStatusChange), for: .valueChanged)
        singInBtn.addTarget(self, action: #selector(handleLogin), for: .touchUpInside)
        checkUserInput()

    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        playAnimation()
    }
    
    func playAnimation() {
        
        animationView.animation = Animation.named(Lottie.profile.rawValue)
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
            UIStoryboard.auth.instantiateViewController(withIdentifier: "RegisterPage")
                as? AuthRegisterViewController else { return }
        
        authVC.modalPresentationStyle = .overCurrentContext
        present(authVC, animated: false, completion: nil)

    }
    
    @objc func handleLogin() {
        //登入
        guard let email = emailTextField.text,
            let psw = pswTextField.text else { return }
        FirebaseManager.shared.singInWithEmail(email: email, psw: psw) { [weak self] isSuccess in
            guard let uiStatus = self?.uiStatus else {
                return
            }

            switch uiStatus {
            case .userLogin:
                FirebaseManager.shared.getCurrentUserData(completion: {[weak self] (data) in
                    guard data != nil else {
                        print("老闆使用了吃貨登入")
                        //老闆使用了吃貨登入, 提示請使用者使用老闆登入
                        do {
                            try Auth.auth().signOut()
                        } catch let err {
                            print(err.localizedDescription)
                        }
                        return
                    }
                    //吃貨登入成功
                    FirebaseManager.shared.userID = Auth.auth().currentUser?.uid
                    self?.presentingViewController?.dismiss(animated: false, completion: nil)
                    
                    guard let rootVC = AppDelegate.shared.window?.rootViewController
                        as? TabBarViewController else { return }
                    rootVC.tabBar.isHidden = false
                })
            case .bossLogin:
                FirebaseManager.shared.getCurrentBossData(completion: { [weak self] (bossData) in
                    guard bossData != nil else {
                        print("吃貨使用了老闆登入")
                        //吃貨使用了老闆登入, 提示請使用者使用吃貨登入
                        do {
                            try Auth.auth().signOut()
                        } catch let err {
                            print(err.localizedDescription)
                        }
                        return
                    }
                    //老闆登入成功
                    FirebaseManager.shared.bossID = Auth.auth().currentUser?.uid
                    self?.presentingViewController?.dismiss(animated: false, completion: nil)
                    guard let rootVC = AppDelegate.shared.window?.rootViewController
                        as? TabBarViewController else { return }
                    rootVC.tabBar.isHidden = false
                })

            }
        }

    }
    
    @objc func handleUIStatusChange() {
        uiStatus = loginSegment.selectedSegmentIndex == 0 ? .userLogin : .bossLogin
        updateUIWithStatus()
    }
    
    func updateUIWithStatus() {
        switch uiStatus {
        case .userLogin:
            singInBtn.setTitle("吃貨登入", for: .normal)
        case .bossLogin:
            singInBtn.setTitle("老闆登入", for: .normal)
        }
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
