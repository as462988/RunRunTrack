//
//  FeedbackViewController.swift
//  RunRunTruck
//
//  Created by yueh on 2019/9/24.
//  Copyright © 2019 yueh. All rights reserved.
//

import UIKit
import MessageUI

class FeedbackViewController: UIViewController {
    
    @IBOutlet weak var nameText: UITextField!
    @IBOutlet weak var emailText: UITextField!
    @IBOutlet weak var titleText: UITextField!
    @IBOutlet weak var questionText: UITextField!
    @IBOutlet weak var checkBtn: UIButton!
    
    var userLoginIsFinished = false {
        didSet {
            updateRegisteBtnStatus()
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        nameText.delegate = self
        emailText.delegate = self
        titleText.delegate = self
        questionText.delegate = self
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(
             image: UIImage.asset(.Icon_back),
             style: .plain,
             target: self,
             action: #selector(backToRoot))
        
        setLayout()
        setValue()
        checkBtn.addTarget(self, action: #selector(clickCheckBtn), for: .touchUpInside)
        checkUserInput()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.isNavigationBarHidden = false
        
    }
    
    func setLayout() {
     
        checkBtn.layer.cornerRadius = 10
        checkBtn.clipsToBounds = true
    }
    
    func setValue() {
        
        guard let user = FirebaseManager.shared.currentUser else {return}
        nameText.text = user.name
        emailText.text = user.email
        
    }
    
    @objc func backToRoot() {
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc func clickCheckBtn() {
        sendFeedbackMessage()
    }
    
    func sendFeedbackMessage() {
        
        if FirebaseManager.shared.userID != nil {
        
            FirebaseManager.shared.creatFeedback(user: User.user.rawValue,
                                             uid: FirebaseManager.shared.userID!,
                                             title: titleText.text!,
                                             detailText: questionText.text!)
            
        } else if FirebaseManager.shared.bossID != nil {
            
            FirebaseManager.shared.creatFeedback(
                user: Boss.boss.rawValue,
                uid: FirebaseManager.shared.bossID!,
                title: titleText.text!,
                detailText: questionText.text!)
            
        }
        showAlert()
    }
    
    func showAlert() {
        
        let thankAlertVC = UIAlertController(title: "感謝你的意見", message: "我們將根據您的意見做改進！", preferredStyle: .alert)
        present(thankAlertVC, animated: true, completion: nil)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            self.dismiss(animated: true, completion: nil)
            self.navigationController?.popViewController(animated: true)
        }
    }
    
}

extension FeedbackViewController: UITextFieldDelegate {
    
    func checkUserInput() {
        
        guard let email = emailText.text,
            let name = nameText.text,
            let text = titleText.text,
            let question = questionText.text else { return }
        
        if !email.isEmpty, !name.isEmpty, !text.isEmpty, !question.isEmpty {
            
            userLoginIsFinished = true
            
        } else {

            userLoginIsFinished = false
        }
    }
    
    func updateRegisteBtnStatus() {
        
        setBtnStatus(userLoginIsFinished ? .enable: .disable, btn: checkBtn)
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        
        checkUserInput()
    }
}
