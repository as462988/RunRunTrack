//
//  SettingRow.swift
//  RunRunTruck
//
//  Created by yueh on 2019/9/24.
//  Copyright © 2019 yueh. All rights reserved.
//

import UIKit
private enum SettingRowStatus {
    case close, expand
}

protocol SettingRowDelegate: class {
    func settingRowDidTap(settingRow: SettingRow)
}

class SettingRow: UIView {
    static let closeRowHeight: CGFloat = 80
    static let expandRowHeight: CGFloat = 300
    static let topButtonHeight: CGFloat = SettingRow.closeRowHeight
    static let contentViewHeight: CGFloat = SettingRow.expandRowHeight - SettingRow.closeRowHeight
    var topButton: UIButton = {
        let btn = UIButton(type: .custom)
        btn.backgroundColor = .white
        btn.addTarget(self, action: #selector(topBtnDidTap), for: .touchUpInside)
        return btn
    }()
    
    var customTitleLabel: UILabel = {
       let label = UILabel()
        label.font = .systemFont(ofSize: 24)
        label.textColor = .darkGray
        return label
    }()
    
    var subTitleLabel: UILabel = {
       let label = UILabel()
        label.font = .systemFont(ofSize: 24)
        label.textColor = .darkGray
        return label
    }()
    
    var withRightArrow: Bool!
    var heightConstraint: NSLayoutConstraint!
    var contentViewController: UIViewController?

    fileprivate var rowStatus: SettingRowStatus = .close
    weak var delegate: SettingRowDelegate?
    
    init(title: String, subTitle: String?, withRightArrow: Bool, associatedContentViewController: UIViewController?) {
        self.customTitleLabel.text = title
        self.subTitleLabel.text = subTitle
        self.withRightArrow = withRightArrow
        self.contentViewController = associatedContentViewController
        super.init(frame: .zero)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
        
    func setupViews() {
        guard let superView = superview else {
            return
        }
        translatesAutoresizingMaskIntoConstraints = false
        self.leadingAnchor.constraint(equalTo: superView.leadingAnchor).isActive = true
        self.trailingAnchor.constraint(equalTo: superView.trailingAnchor).isActive = true
        heightConstraint = self.heightAnchor.constraint(equalToConstant: SettingRow.closeRowHeight)
        heightConstraint.isActive = true
        
        self.addSubview(topButton)
        topButton.translatesAutoresizingMaskIntoConstraints = false
        topButton.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        topButton.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
        topButton.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
        topButton.heightAnchor.constraint(equalToConstant: SettingRow.topButtonHeight).isActive = true
        
        topButton.addSubview(customTitleLabel)
        customTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        customTitleLabel.centerYAnchor.constraint(
            equalTo: topButton.centerYAnchor).isActive = true
        customTitleLabel.leadingAnchor.constraint(
            equalTo: topButton.leadingAnchor, constant: 20).isActive = true
        
        if withRightArrow {
            //這裡可以改為圖片比較漂亮
//            let rightArrow = UIImageView()
//            rightArrow.image =
            let rightArrow = UILabel()
            rightArrow.font = .boldSystemFont(ofSize: 24)
            rightArrow.text = "〉"
            rightArrow.textColor = .lightGray
            topButton.addSubview(rightArrow)
            rightArrow.translatesAutoresizingMaskIntoConstraints = false
            rightArrow.centerYAnchor.constraint(
                equalTo: customTitleLabel.centerYAnchor).isActive = true
            rightArrow.trailingAnchor.constraint(
                equalTo: self.trailingAnchor, constant: -10).isActive = true
        }
        
        topButton.addSubview(subTitleLabel)
        subTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        subTitleLabel.centerYAnchor.constraint(
            equalTo: customTitleLabel.centerYAnchor).isActive = true
        subTitleLabel.trailingAnchor.constraint(
            equalTo: self.trailingAnchor, constant: -10).isActive = true
        
        let bottomLine = UIView()
        topButton.addSubview(bottomLine)
        bottomLine.backgroundColor = .lightGray
        bottomLine.translatesAutoresizingMaskIntoConstraints = false
        bottomLine.leadingAnchor.constraint(equalTo: topButton.leadingAnchor, constant: 20).isActive = true
        bottomLine.bottomAnchor.constraint(equalTo: topButton.bottomAnchor).isActive = true
        bottomLine.trailingAnchor.constraint(equalTo: topButton.trailingAnchor).isActive = true
        bottomLine.heightAnchor.constraint(equalToConstant: 0.5).isActive = true
        
        if let contentVc = contentViewController {
            self.addSubview(contentVc.view)
            contentVc.view.translatesAutoresizingMaskIntoConstraints = false
            contentVc.view.topAnchor.constraint(equalTo: topButton.bottomAnchor).isActive = true
            contentVc.view.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
            contentVc.view.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
            contentVc.view.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true

        }
    }
}

extension SettingRow {
    @objc func topBtnDidTap() {
        self.delegate?.settingRowDidTap(settingRow: self)
    }
}

extension SettingRow {
    func toggleContent() {
        switch rowStatus {
        case .close:
            rowStatus = .expand
            heightConstraint.constant = SettingRow.expandRowHeight
        case .expand:
            rowStatus = .close
            heightConstraint.constant = SettingRow.closeRowHeight
        }
    }
}
