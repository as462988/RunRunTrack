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
        
        emailTextField.text = "yueh@gmail.com"
        pswTextField.text = "yyyyyy"
        
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
                self?.userLogin(useAppleSingIn: false)
            case .bossLogin:
                self?.bossLogin(useAppleSingIn: false)
            }
        }
    }
    
    func userLogin(useAppleSingIn: Bool, user: AppleUser? = nil) {
        
        FirebaseManager.shared.listenUserData(isAppleSingIn: useAppleSingIn, userid: user?.id)
        FirebaseManager.shared.getCurrentUserData(
            useAppleSingIn: useAppleSingIn,
            userId: user?.id) {[weak self] (data) in
                guard data != nil else {
                    self?.errorResultLabel.isHidden = false
                    self?.errorResultLabel.text = "目前找不到此帳號主人喔！"
                    do {
                        try Auth.auth().signOut()
                    } catch let err {
                        print(err.localizedDescription)
                    }
                    return
                }
                //吃貨登入成功
                FirebaseManager.shared.userID = Auth.auth().currentUser?.uid
                FirebaseManager.shared.updataData(type: User.user.rawValue,
                                                      uid: Auth.auth().currentUser?.uid ?? "",
                                                      key: User.token.rawValue,
                                                      value: FirebaseManager.shared.currentUserToken)
                ProgressHUD.showSuccess(text: "登入成功")
                DispatchQueue.main.async {
                    self?.presentingViewController?.dismiss(animated: false, completion: nil)
                    guard let rootVC = AppDelegate.shared.window?.rootViewController
                        as? TabBarViewController else { return }
                    rootVC.tabBar.isHidden = false
                }
        }
    }
    
    func bossLogin(useAppleSingIn: Bool, user: AppleUser? = nil) {
        
        FirebaseManager.shared.getCurrentBossData(
            isAppleSingIn: useAppleSingIn,
            userid: user?.id) { [weak self] (bossData) in
                guard bossData != nil else {
                    self?.errorResultLabel.isHidden = false
                    self?.errorResultLabel.text = "目前找不到此帳號主人喔！"
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
        emptyText()
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
    
    func checkUserLogoinWithApple(user: AppleUser) {
        
        FirebaseManager.shared.listenUserData(isAppleSingIn: true, userid: user.id)
        FirebaseManager.shared.checkExistUser(
            userType: User.user.rawValue,
            uid: user.id) { (isExist) in
                //如果不存在就先註冊
                if isExist == false {
                    FirebaseManager.shared.setUserData(
                        name: user.lastName + ", " + user.firstName,
                        email: user.email,
                        isAppleSingIn: true,
                        appleUID: user.id)
                    
                }
                //註冊完直接登入
                FirebaseManager.shared.getCurrentUserData(
                useAppleSingIn: true, userId: user.id) { [weak self](userData) in
                    guard userData != nil else { return }
                    
                    FirebaseManager.shared.userID = user.id
                    ProgressHUD.showSuccess(text: "登入成功")
                    
                    DispatchQueue.main.async {
                        self?.presentingViewController?.dismiss(animated: false, completion: nil)
                        guard let rootVC = AppDelegate.shared.window?.rootViewController
                            as? TabBarViewController else { return }
                        rootVC.tabBar.isHidden = false
                    }
                }
        }
    }
    func checkBossLogoinWithApple(user: AppleUser) {
        
        FirebaseManager.shared.checkExistUser(
            userType: Boss.boss.rawValue,
            uid: user.id) { [weak self](isExist) in
                
                if isExist == false {
                    
                    FirebaseManager.shared.setBossData(
                        name: user.lastName + ", " + user.firstName,
                        email: user.email,
                        isAppleSingIn: true,
                        appleUID: user.id)
                    
                    self?.addTruckInBoss(needEnterName: true, bossId: user.id)
                    return
                }
                
                FirebaseManager.shared.getCurrentBossData(
                isAppleSingIn: true, userid: user.id) { [weak self](userData) in
                    guard userData != nil else { return }
                    
                    FirebaseManager.shared.bossID = user.id
                    ProgressHUD.showSuccess(text: "登入成功")
                    
                    DispatchQueue.main.async {
                        self?.presentingViewController?.dismiss(animated: false, completion: nil)
                        guard let rootVC = AppDelegate.shared.window?.rootViewController
                            as? TabBarViewController else { return }
                        rootVC.tabBar.isHidden = false
                    }
                }
        }
    }
    
    func addTruckInBoss(needEnterName: Bool, bossId: String? = nil) {
        
        guard let addTruckVC = UIStoryboard.auth.instantiateViewController(
            withIdentifier: String(describing: AddBossTruckViewController.self))
            as? AddBossTruckViewController else { return }
        
        addTruckVC.modalPresentationStyle = .overCurrentContext
        addTruckVC.needEnterName = needEnterName
        addTruckVC.appleSinginBossID = bossId
        self.present(addTruckVC, animated: false, completion: nil)
    }
    
    func authorizationController(controller: ASAuthorizationController,
                                 didCompleteWithAuthorization authorization: ASAuthorization) {
        
        switch authorization.credential {
            
        case let credentials as ASAuthorizationAppleIDCredential:
            let user = AppleUser(credentials: credentials)
            
            switch uiStatus {
            case .userLogin:
                checkUserLogoinWithApple(user: user)
            case .bossLogin:
                checkBossLogoinWithApple(user: user)
            }
            
        default: break
            
        }
    }
    
//    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
//        print("something bad happened", error)
//    }
}

extension AuthViewController: ASAuthorizationControllerPresentationContextProviding {
    func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
        
        return view.window!
        
    }
}
