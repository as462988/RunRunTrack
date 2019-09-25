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
import Lottie
import AuthenticationServices

private enum RegisterVcUIStatus {
    case userRegister, bossRegister
}

class AuthRegisterViewController: UIViewController {
    
    @IBOutlet weak var segmentRegister: UISegmentedControl!
    @IBOutlet weak var contentView: UIView!
    
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var pswTextField: UITextField!
    @IBOutlet weak var pswConfirmTextField: UITextField!
    @IBOutlet weak var registerBtn: UIButton!
    @IBOutlet weak var animationOne: AnimationView!
    @IBOutlet weak var animationTwo: AnimationView!
    @IBOutlet weak var animationThird: AnimationView!
    @IBOutlet weak var errorResultLabel: UILabel!
    
     private var uiStatus: RegisterVcUIStatus = .userRegister
    
    var userRegisteIsFinished = false {
        didSet {
            updateRegisteBtnStatus()
        }
    }

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
        
        setupView()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        errorResultLabel.isHidden = true
        playAnimation()
    }
    
    @IBAction func dismissView(_ sender: Any) {
        
        presentingViewController?.dismiss(animated: false, completion: nil)
    }
    
    @objc func handleRegisterBtn() {
        
        guard let name = nameTextField.text,
            let email = emailTextField.text,
            let psw = pswTextField.text else { return }
        
        FirebaseManager.shared.userRegister(email: email, psw: psw) { [weak self] (isSuccess, result) in
            
            guard isSuccess else {
                self?.errorResultLabel.isHidden = false
                self?.errorResultLabel.text = result
                return
            }
            
            guard let uiStatus = self?.uiStatus else {return}
            
            switch uiStatus {
            case .userRegister:
                
                self?.userRegister(name: name, email: email)
                
            case .bossRegister:
                
                self?.bossRegister(name: name, email: email)
                
            }
//
//            if self?.segmentRegister.selectedSegmentIndex == 0 {
//
//                self?.presentingViewController?.dismiss(animated: false, completion: nil)
//                FirebaseManager.shared.setUserData(name: name, email: email)
//
//            } else {
//
//                guard let addTruckVC = UIStoryboard.auth.instantiateViewController(withIdentifier: "adTruckVC")
//                    as? AddBossTruckViewController else { return }
//
//                addTruckVC.modalPresentationStyle = .overCurrentContext
//                self?.present(addTruckVC, animated: false, completion: nil)
//
//                FirebaseManager.shared.setBossData(name: name, email: email)
//            }
        }
    }
    
    func userRegister(name: String, email: String) {

        self.presentingViewController?.dismiss(animated: false, completion: nil)
        FirebaseManager.shared.setUserData(name: name, email: email)
        
    }
    
    func bossRegister(name: String, email: String) {
        
        guard let addTruckVC = UIStoryboard.auth.instantiateViewController(withIdentifier: "adTruckVC")
            as? AddBossTruckViewController else { return }
        
        addTruckVC.modalPresentationStyle = .overCurrentContext
        self.present(addTruckVC, animated: false, completion: nil)
        
        FirebaseManager.shared.setBossData(name: name, email: email)
        
    }
    
    
    
    @objc func handleRegisterChange() {
        
        uiStatus = segmentRegister.selectedSegmentIndex == 0 ? .userRegister : .bossRegister
          updateUIWithStatus()
        
        
//        let title = segmentRegister.titleForSegment(at: segmentRegister.selectedSegmentIndex)
//        registerBtn.setTitle(title, for: .normal)

 
    }
    
        func updateUIWithStatus() {
            switch uiStatus {
            case .userRegister:
                registerBtn.setTitle("吃貨註冊", for: .normal)
            case .bossRegister:
                registerBtn.setTitle("老闆註冊", for: .normal)
                getText()
            }
    //        emptyText()
        }
    
    
    func getText() {
        
        var i = 4
        nameTextField.text = "boss\(i)"
        emailTextField.text = "boss\(i)@gmail.com"
        pswTextField.text = "bossboss"
        pswConfirmTextField.text = "bossboss"
        
        i += 1
    }
    
    func emptyText() {
        nameTextField.text = ""
        emailTextField.text = ""
        pswTextField.text = ""
        pswConfirmTextField.text = ""
        errorResultLabel.text = ""
    }
    
    func playAnimation() {
        
        let urlFirst = URL(string: "https://assets7.lottiefiles.com/temporary_files/2EMn10.json")
        let urlSecond = URL(string: "https://assets7.lottiefiles.com/temporary_files/vGyy7K.json")
        let urlThird = URL(string: "https://assets7.lottiefiles.com/temporary_files/Fpip5r.json")
        
        Animation.loadedFrom(url: urlFirst!,
                             closure: { [weak self](animation) in
                                self?.animationOne.animation = animation
                                self?.animationOne.loopMode = .loop
                                self?.animationOne.play()
            }, animationCache: nil)
        
        Animation.loadedFrom(url: urlSecond!,
                             closure: { [weak self](animation) in
                                self?.animationTwo.animation = animation
                                self?.animationTwo.loopMode = .loop
                                self?.animationTwo.play()
            }, animationCache: nil)
        
        Animation.loadedFrom(url: urlThird!,
                             closure: { [weak self](animation) in
                                self?.animationThird.animation = animation
                                self?.animationThird.loopMode = .loop
                                self?.animationThird.play()
            }, animationCache: nil)

    }
     func setupView() {
           let appleButton = ASAuthorizationAppleIDButton()
           appleButton.translatesAutoresizingMaskIntoConstraints = false
           appleButton.addTarget(self, action: #selector(didTapAppleButton), for: .touchUpInside)

           view.addSubview(appleButton)

           appleButton.anchor(top: registerBtn.bottomAnchor,
                              leading: view.leadingAnchor,
                              bottom: view.bottomAnchor,
                              trailing: view.trailingAnchor,
                              padding: .init(top: 10, left: 20, bottom: 30, right: 20),
                              size: CGSize(width: registerBtn.frame.width, height: registerBtn.frame.height))
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

}

extension AuthRegisterViewController: UITextFieldDelegate {

    func checkUserInput() {
        
        guard let name = nameTextField.text,
            let email = emailTextField.text,
            let psw = pswTextField.text,
            let pswConfirm = pswConfirmTextField.text else { return }
        
        if !name.isEmpty, !email.isEmpty, !psw.isEmpty, !pswConfirm.isEmpty {
            
            guard pswConfirm.elementsEqual(psw) else {
                    errorResultLabel.isHidden = false
                    errorResultLabel.text = "兩次密碼輸入不一致喔！"
                    userRegisteIsFinished = false
                        return
                    }
            
            userRegisteIsFinished = true
            
        } else {
            errorResultLabel.isHidden = false
            errorResultLabel.text = "請輸入完整資料～"
            userRegisteIsFinished = false
        }
    }
    
    func updateRegisteBtnStatus() {
        
        setBtnStatus(userRegisteIsFinished ? .enable: .disable, btn: registerBtn)
    }

    func textFieldDidEndEditing(_ textField: UITextField) {
        
        checkUserInput()
    }
}

extension AuthRegisterViewController: ASAuthorizationControllerDelegate {
    func authorizationController(controller: ASAuthorizationController,
                                 didCompleteWithAuthorization authorization: ASAuthorization) {

        switch authorization.credential {

        case let credentials as ASAuthorizationAppleIDCredential:
            let user = AppleUser(credentials: credentials)
            
            print(user)
            
            FirebaseManager.shared.setUserData(
                name: user.lastName + ", " + user.firstName,
                email: user.email)
            
        default: break

        }

    }

    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
        print("something bad happened", error)
    }
}

extension AuthRegisterViewController: ASAuthorizationControllerPresentationContextProviding {
    func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {

        return view.window!

    }
}

