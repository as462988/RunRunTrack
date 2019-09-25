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
import AuthenticationServices

private enum LoginVcUIStatus {
    case userLogin, bossLogin
}

class AuthViewController: UIViewController {
    
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var loginSegment: UISegmentedControl!
    @IBOutlet weak var singInBtn: UIButton!
    @IBOutlet weak var pswTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var errorResultLabel: UILabel!
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
        errorResultLabel.isHidden = true
        playAnimation()
        setupView()
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
        emptyText()
    }
    func setupView() {
        let appleButton = ASAuthorizationAppleIDButton()
        appleButton.translatesAutoresizingMaskIntoConstraints = false
        appleButton.addTarget(self, action: #selector(didTapAppleButton), for: .touchUpInside)

        view.addSubview(appleButton)

        appleButton.anchor(top: singInBtn.bottomAnchor,
                           leading: view.leadingAnchor,
                           bottom: view.bottomAnchor,
                           trailing: view.trailingAnchor,
                           padding: .init(top: 10, left: 20, bottom: 30, right: 20),
                           size: CGSize(width: singInBtn.frame.width, height: singInBtn.frame.height))
    }
    
    @objc func didTapAppleButton() {
        
        let provider = ASAuthorizationAppleIDProvider()
            let request = provider.createRequest()
            request.requestedScopes = [.fullName, .email]

            let controller = ASAuthorizationController(authorizationRequests: [request])

            controller.delegate = self
            controller.presentationContextProvider = self

            controller.performRequests()
        
    }
    
    @objc func handleLogin() {
        //登入
        guard let email = emailTextField.text,
            let psw = pswTextField.text else { return }
        
        FirebaseManager.shared.singInWithEmail(email: email, psw: psw) { [weak self] (isSuccess, result) in
            
            guard isSuccess else {
                self?.errorResultLabel.isHidden = false
                self?.errorResultLabel.text = result
                return
            }
            
            guard let uiStatus = self?.uiStatus else {
                return
            }
            
            switch uiStatus {
            case .userLogin:
                self?.userLogin()
            case .bossLogin:
                self?.bossLogin()
            }
        }
    }
    
    func userLogin() {
        
        FirebaseManager.shared.listenUserData()
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
                            ProgressHUD.showSuccess(text: "登入成功")
                               
                               DispatchQueue.main.async {
                                   self?.presentingViewController?.dismiss(animated: false, completion: nil)
                                   guard let rootVC = AppDelegate.shared.window?.rootViewController
                                       as? TabBarViewController else { return }
                                   rootVC.tabBar.isHidden = false
                               }
                        })
    }
    
    func bossLogin() {
        
              FirebaseManager.shared.listenUserData()
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
                            ProgressHUD.showSuccess(text: "登入成功")
                            
                            DispatchQueue.main.async {
                                self?.presentingViewController?.dismiss(animated: false, completion: nil)
                                guard let rootVC = AppDelegate.shared.window?.rootViewController
                                    as? TabBarViewController else { return }
                                rootVC.tabBar.isHidden = false
                            }
                        })
    }
    
    @objc func handleUIStatusChange() {
        uiStatus = loginSegment.selectedSegmentIndex == 0 ? .userLogin : .bossLogin
        updateUIWithStatus()
    }
    
    func updateUIWithStatus() {
        switch uiStatus {
        case .userLogin:
            singInBtn.setTitle("吃貨登入", for: .normal)
            emailTextField.text = "yueh@gmail.com"
            pswTextField.text = "yyyyyy"
        case .bossLogin:
            singInBtn.setTitle("老闆登入", for: .normal)
            emailTextField.text = "boss@gmail.com"
            pswTextField.text = "bossboss"
        }
//        emptyText()
    }
    
    func emptyText() {
        emailTextField.text = ""
        pswTextField.text = ""
        errorResultLabel.text = ""
    }
}

extension AuthViewController: UITextFieldDelegate {
    
    func checkUserInput() {
        
        guard let email = emailTextField.text,
            let psw = pswTextField.text else { return }
                
        if !email.isEmpty, !psw.isEmpty {
            
            userLoginIsFinished = true
            
        } else {

            userLoginIsFinished = false
        }
    }
    
    func updateRegisteBtnStatus() {
        
        setBtnStatus(userLoginIsFinished ? .enable: .disable, btn: singInBtn)
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        
        checkUserInput()
    }
}

extension AuthViewController: ASAuthorizationControllerDelegate {
    func authorizationController(controller: ASAuthorizationController,
                                 didCompleteWithAuthorization authorization: ASAuthorization) {

        switch authorization.credential {

        case let credentials as ASAuthorizationAppleIDCredential:
            let user = AppleUser(credentials: credentials)
            
            print(user)
            
//            FirebaseManager.shared.setUserData(
//                name: user.lastName + ", " + user.firstName,
//                email: user.email)
            
        default: break

        }

    }

    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
        print("something bad happened", error)
    }
}

extension AuthViewController: ASAuthorizationControllerPresentationContextProviding {
    func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {

        return view.window!

    }
}
