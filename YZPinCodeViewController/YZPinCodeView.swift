//
//  YZPinCodeViewController.swift
//  MoneyKeeper
//
//  Created by Yaroslav Zavyalov on 03/07/2019.
//  Copyright © 2019 ZYG. All rights reserved.
//

import UIKit


enum YZPinCodeType: Int {
    
    /// Create new pin code
    case create = 0
    
    /// Confirm new pin code
    case confirm = 1
    
    /// Delete current pin code
    case delete = 2
    
    /// Change pin code
    case change = 3
    
    /// Enter pin code when start application
    case enter = 4
}


class YZPinCodeViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
}

extension YZPinCodeView
