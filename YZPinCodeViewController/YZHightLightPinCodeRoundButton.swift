//
//  YZHightLightPinCodeRoundButton.swift
//  MoneyKeeper
//
//  Created by Yaroslav Zavyalov on 03/07/2019.
//  Copyright © 2019 ZYG. All rights reserved.
//

import UIKit

// MARK: - YZHightLightPinCodeRoundButton round button
open class YZHightLightPinCodeRoundButton: YZPinCodeRoundButton {
    
    override open var isHighlighted: Bool {
        didSet {
            backgroundColor = isHighlighted ? .lightGray : self.bckGroundColor
        }
    }
}

