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
            updateRegisterBtnStatus()
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
        singInBtn.addTarget(self, action: #selector(handleEmailLogin), for: .touchUpInside)
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
            UIStoryboard.auth.instantiateViewController(
                withIdentifier: String(describing: AuthRegisterViewController.self))
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
        emptyText()
    }
    
    func emptyText() {
        emailTextField.text = ""
        pswTextField.text = ""
        errorResultLabel.text = ""
    }
}

// MARK: UITextFieldDelegate

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
    
    func updateRegisterBtnStatus() {
        
        setBtnStatus(userLoginIsFinished ? .enable: .disable, btn: singInBtn)
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        
        checkUserInput()
    }
}

// MARK: Login flow

extension AuthViewController {
    
    fileprivate func checkIfUserDataExisted(
        userType: UserType,
        userIdentifier: String,
        completion: @escaping (UserData?) -> Void) {
        
        FirebaseManager.shared.getCurrentUserData(
        userType: userType,
        userIdentifier: userIdentifier) { [weak self] userData in
            
            guard userData != nil else {
                
                DispatchQueue.main.async {
                    self?.errorResultLabel.isHidden = false
                    self?.errorResultLabel.text = "目前找不到此帳號主人喔！"
                }
            
                completion(nil)
                
                return
            }
            completion(userData)
        }
    }
    
    fileprivate func goToCreateTruckWithBossId(_ bossId: String) {
        
        guard let addTruckVC = UIStoryboard.auth.instantiateViewController(
            withIdentifier: String(describing: AddBossTruckViewController.self))
            as? AddBossTruckViewController else { return }
        
        addTruckVC.bossId = bossId
            
        addTruckVC.modalPresentationStyle = .overCurrentContext
        
        self.present(addTruckVC, animated: false, completion: nil)
    }
    
    fileprivate func dismissModalWhenLoginSuccess() {
        ProgressHUD.showSuccess(text: "登入成功")
        DispatchQueue.main.async {
            self.presentingViewController?.dismiss(animated: false, completion: nil)
            guard let rootVC = AppDelegate.shared.window?.rootViewController
                as? TabBarViewController else { return }
            rootVC.tabBar.isHidden = false
        }
    }
}

// MARK: Email Login

extension AuthViewController {
    ///用戶使用Email登入
    @objc func handleEmailLogin() {
        
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
            ///驗證成功
            guard let uid = Auth.auth().currentUser?.uid else { return }
            switch uiStatus {
            case .userLogin:
                self?.checkIfUserDataExisted(userType: .normalUser, userIdentifier: uid) { userData in
                    guard let userData = userData else {
                        //用戶不存在
                        try? Auth.auth().signOut()
                        return
                    }
                    //使用者存在
                    FirebaseManager.shared.setupCurrentUserDataWhenLoginSuccess(userData: userData)
                    self?.dismissModalWhenLoginSuccess()
                }
            case .bossLogin:
                self?.checkIfUserDataExisted(userType: .boss, userIdentifier: uid) { userData in
                    guard let userData = userData else {
                        //用戶不存在
                        try? Auth.auth().signOut()
                        return
                    }
                    guard userData.truckId != nil else {
                        //老闆還沒新增餐車資料
                        self?.goToCreateTruckWithBossId(uid)
                        return
                    }
                    //老闆存在
                    FirebaseManager.shared.setupCurrentUserDataWhenLoginSuccess(userData: userData)
                    self?.dismissModalWhenLoginSuccess()
                }
            }
        }
    }
}

// MARK: Apple Sign In

extension AuthViewController: ASAuthorizationControllerDelegate {
    
    func authorizationController(controller: ASAuthorizationController,
                                 didCompleteWithAuthorization authorization: ASAuthorization) {
        
        if let appleIDCredential = authorization.credential as? ASAuthorizationAppleIDCredential {
            
            let appleUser = AppleUser(credentials: appleIDCredential)
            
            switch uiStatus {
                
            case .userLogin:
                
                handleAppleUserLogin(user: appleUser)
                
            case .bossLogin:
                handleAppleBossLogin(user: appleUser)
                
            }
        }
    }
    
    private func handleAppleUserLogin(user: AppleUser) {
        
        checkIfUserDataExisted(
            userType: .normalUser,
            userIdentifier: user.id) {[weak self] userData in
                guard let userData = userData else {
                    //使用者還沒註冊，建立資料
                    FirebaseManager.shared.setNormalUserData(
                        name: user.defaultDisplayName(),
                        email: user.email,
                        userIdentifier: user.id) { success in
                            if success {
                                FirebaseManager.shared.getCurrentUserData(
                                    userType: .normalUser,
                                    userIdentifier: user.id) { (user) in
                                        if let user = user {
                                            FirebaseManager.shared.setupCurrentUserDataWhenLoginSuccess(
                                                userData: user)
                                            self?.dismissModalWhenLoginSuccess()
                                        }
                                }
                            }
                    }
                    return
                }
                FirebaseManager.shared.setupCurrentUserDataWhenLoginSuccess(userData: userData)
                self?.dismissModalWhenLoginSuccess()
        }
    }
    
    private func handleAppleBossLogin(user: AppleUser) {
        
        checkIfUserDataExisted(userType: .boss, userIdentifier: user.id) { [weak self] userData in
            guard let userData = userData else {
                //老闆還沒註冊，建立資料
                FirebaseManager.shared.setBossData(
                    name: user.defaultDisplayName(),
                    email: user.email, userIdentifier: user.id) { success in
                    if success {
                        FirebaseManager.shared.getCurrentUserData(
                        userType: .boss,
                        userIdentifier: user.id) { (user) in
                            if let user = user {
                                FirebaseManager.shared.setupCurrentUserDataWhenLoginSuccess(userData: user)
                                self?.goToCreateTruckWithBossId(user.uid)
                            }
                        }
                    }
                }
                return
            }
            guard userData.truckId != nil else {
                //老闆還沒新增餐車資料
                self?.goToCreateTruckWithBossId(userData.uid)
                return
            }
            //老闆存在
            FirebaseManager.shared.setupCurrentUserDataWhenLoginSuccess(userData: userData)
            self?.dismissModalWhenLoginSuccess()
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
