//
//  YZPinCodeErrorView.swift
//  MoneyKeeper
//
//  Created by Yaroslav Zavyalov on 04/07/2019.
//  Copyright © 2019 ZYG. All rights reserved.
//

import UIKit

// MARK: - YZPinCodeErrorView
class YZPinCodeErrorView: UIView {
    
    public var label = UILabel()
    
    override public init(frame: CGRect) {
        super.init(frame: frame)
        self.createUI()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.createUI()
    }
}

// MARK: - Privates
extension YZPinCodeErrorView {
    
    private func createUI() {
        self.alpha = 0
        self.backgroundColor = .white
        self.layer.cornerRadius = 10
        
        self.label.font = UIFont.systemFont(ofSize: 13)
        self.label.numberOfLines = 0
        self.label.textAlignment = .center
        self.addSubview(self.label)
        let attributes: [NSLayoutConstraint.Attribute] = [.top, .left, .right, .bottom]
        self.label.translatesAutoresizingMaskIntoConstraints = false
        attributes.forEach {
            NSLayoutConstraint(item: self.label, attribute: $0, relatedBy: .equal, toItem: self, attribute: $0, multiplier: 1, constant: 0).isActive = true
        }
    }
}

// MARK: - Publics
extension YZPinCodeErrorView {
    
    public func displayError(_ error: String) {
        self.label.text = error
    }
}
