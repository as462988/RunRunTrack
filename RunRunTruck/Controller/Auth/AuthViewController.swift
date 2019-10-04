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
                self?.handleUserLogin(useAppleSingIn: false)
            case .bossLogin:
                self?.handleBossLogin(useAppleSingIn: false)
            }
        }
    }
    
    func handleUserLogin(useAppleSingIn: Bool, currentUser: AppleUser? = nil) {
        
        //開始監聽 User 的資料
        FirebaseManager.shared.listenUserData(isAppleSingIn: useAppleSingIn, userid: currentUser?.id)
        
        //如果是 AppleSingIn 判斷是否註冊過
        if useAppleSingIn {
            guard let user = currentUser else { return }
            checkUserExit(userType: User.user.rawValue, user: user, completion: nil)
            getUserData(useAppleSingIn: useAppleSingIn, user: user)
        } else {
            getUserData(useAppleSingIn: useAppleSingIn)
        }
    }
    
    func handleBossLogin(useAppleSingIn: Bool, currentUser: AppleUser? = nil) {
        
        if useAppleSingIn {
             guard let user = currentUser else { return }
            checkUserExit(userType: Boss.boss.rawValue, user: user) { [weak self] in
                self?.addTruckInBoss(needEnterName: true, bossId: user.id)
                return
            }
            getBossData(useAppleSingIn: useAppleSingIn, user: user)

        } else {
            getBossData(useAppleSingIn: useAppleSingIn)
        }
    }
    
    func checkUserExit(userType: String, user: AppleUser, completion: (() -> Void)? = nil) {
        
        FirebaseManager.shared.checkExistUser(userType: userType, uid: user.id) { (isExist) in
            
            if isExist == false {
            
                FirebaseManager.shared.setBossData(
                    name: user.lastName + ", " + user.firstName,
                    email: user.email,
                    isAppleSingIn: true,
                    appleUID: user.id)
                completion?()
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
    
    func getUserData(useAppleSingIn: Bool, user: AppleUser? = nil) {
        FirebaseManager.shared.getCurrentUserData(
                useAppleSingIn: useAppleSingIn,
                userId: user?.id) { [weak self] (data) in
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
                    FirebaseManager.shared.updataData(type: User.user.rawValue,
                                                          uid: Auth.auth().currentUser?.uid ?? "",
                                                          key: User.token.rawValue,
                                                          value: FirebaseManager.shared.currentUserToken)
                    
                    for truckId in data?.favorite ?? [""] {
                        FirebaseNotificationManager.share.subscribeTopic(toTopic: truckId, completion: nil)
                    }

                    ProgressHUD.showSuccess(text: "登入成功")
                    DispatchQueue.main.async {
                        self?.presentingViewController?.dismiss(animated: false, completion: nil)
                        guard let rootVC = AppDelegate.shared.window?.rootViewController
                            as? TabBarViewController else { return }
                        rootVC.tabBar.isHidden = false
                    }
            }
    }
    
    func getBossData(useAppleSingIn: Bool, user: AppleUser? = nil) {
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
                // FirebaseManager.shared.bossID = Auth.auth().currentUser?.uid
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
    
    func updateRegisterBtnStatus() {
        
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
            
            switch uiStatus {
            case .userLogin:
                handleUserLogin(useAppleSingIn: true, currentUser: user)
            case .bossLogin:
                handleBossLogin(useAppleSingIn: true, currentUser: user)
            }
            
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
