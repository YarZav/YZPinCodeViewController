//
//  YZPinCodeRoundButton.swift
//  MoneyKeeper
//
//  Created by Yaroslav Zavyalov on 03/07/2019.
//  Copyright © 2019 ZYG. All rights reserved.
//

import UIKit

// MAKR: - YZPinCodeRoundButton
open class YZPinCodeRoundButton: UIButton {
    
    //Properties
    public var bckGroundColor: UIColor = .white
    
    //Init
    public init(backgroundColor: UIColor, radius: CGFloat, borderColor: UIColor, borderWidth: CGFloat) {
        super.init(frame: .zero)
        self.createUI(backgroundColor: backgroundColor, radius: radius, borderColor: borderColor, borderWidth: borderWidth)
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.createUI(backgroundColor: .white, radius: 450, borderColor: .black, borderWidth: 1)
    }
}

// MARK: - Privates
extension YZPinCodeRoundButton {
    
    private func createUI(backgroundColor: UIColor, radius: CGFloat, borderColor: UIColor, borderWidth: CGFloat) {
        self.bckGroundColor = backgroundColor
        self.backgroundColor = backgroundColor
        self.layer.cornerRadius = radius
        self.layer.borderWidth = 1
        self.layer.borderColor = borderColor.cgColor
    }
}
