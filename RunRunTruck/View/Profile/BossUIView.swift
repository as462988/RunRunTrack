//
//  BossUIView.swift
//  RunRunTruck
//
//  Created by yueh on 2019/9/10.
//  Copyright © 2019 yueh. All rights reserved.
//

import UIKit

class BossUIView: UIView {

    @IBOutlet weak var logoImage: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var storyTextView: UITextView!
    @IBOutlet weak var editBtn: UIButton!
    @IBOutlet weak var logoOutBtn: UIButton!
    @IBOutlet weak var openSwitch: UISwitch!
    @IBOutlet weak var datePicker: UIDatePicker!
     @IBOutlet weak var clickDateBtn: UIButton!

    override func awakeFromNib() {
        super.awakeFromNib()
        setRadius()
        logoOutBtn.addTarget(self, action: #selector(clickLogoutBtn), for: .touchUpInside)
    
        openSwitch.addTarget(self, action: #selector(onChange), for: .valueChanged)
    }
    
    @objc func onChange(sender: AnyObject) {
        
        guard let tempSwitch = sender as? UISwitch else {return}
        
        if tempSwitch.isOn {
            
            datePicker.isHidden = false
            clickDateBtn.isHidden = false
        } else {
            
            datePicker.isHidden = true
            clickDateBtn.isHidden = true
        }
    
    }
    
    @IBAction func choseDate(_ sender: Any) {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm"
        print("現在選擇時間\(formatter.string(from: datePicker.date))")
        print(formatter.string(from: datePicker.date))
    }

    func setupValue() {
        
        guard let data = FirebaseManager.shared.bossTruck else {return}
        
        nameLabel.text = data.name
        storyTextView.text = data.story
    }
    
    func cleanValue() {
        nameLabel.text = ""
        storyTextView.text = ""
    }
    
    func setRadius() {
        
        editBtn.layer.cornerRadius = 10
        editBtn.clipsToBounds = true
        logoOutBtn.layer.cornerRadius = 10
        logoOutBtn.clipsToBounds = true
        storyTextView?.layer.cornerRadius = 10
        storyTextView?.clipsToBounds = true
        
    }
    
    @objc func clickLogoutBtn() {
        
        FirebaseManager.shared.signOut()
        
        let appDelegate = UIApplication.shared.delegate as? AppDelegate
        
        let root = appDelegate?.window?.rootViewController as? TabBarViewController
        
        root?.selectedIndex = 0
        
        cleanValue()
    }
}
