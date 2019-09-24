//
//  FeedbackViewController.swift
//  RunRunTruck
//
//  Created by yueh on 2019/9/24.
//  Copyright © 2019 yueh. All rights reserved.
//

import UIKit

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
        setLayout()
        setValue()
        checkBtn.addTarget(self, action: #selector(clickCheckBtn), for: .touchUpInside)
        checkUserInput()
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
    
    @objc func clickCheckBtn() {
        print(#function)
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
