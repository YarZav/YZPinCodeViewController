//
//  YZPinCodeNumPadView.swift
//  MoneyKeeper
//
//  Created by Yaroslav Zavyalov on 03/07/2019.
//  Copyright © 2019 ZYG. All rights reserved.
//

import UIKit
import LocalAuthentication

/// Tags for number pad
//  1   2   3
//  4   5   6
//  7   8   9
//  10(biomatric)  0  11(delete)

// MARK: - YZPinCodeNumPadView
open class YZPinCodeNumPadView: UIView {
    
    public var biometricAvailable: Bool = false                     // Is biometric using available for app
    public weak var strings: YZPinCodeBiometricStrings?             // Get strings
    public weak var delegate: YZPinCodeNumPadViewDelegate?          // Subscribe to get notification when button tapped
    public weak var designation: YZPinCodeNumPadViewDesignation?    // UI delegate
    
    weak var rootControllerDelegate: YZPinCodeRootController?
    
    private var numTag: Int = 1
    private var type: YZPinCodeBiometricType = .none
    private var biometricButton: UIButton!
    
    override private init(frame: CGRect) {
        super.init(frame: frame)
        self.createUI()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.createUI()
    }
    
    public init(delegate: YZPinCodeNumPadViewDelegate?, designation: YZPinCodeNumPadViewDesignation?, strings: YZPinCodeBiometricStrings?, biometricAvailable: Bool) {
        self.biometricAvailable = biometricAvailable
        self.strings = strings
        self.delegate = delegate
        self.designation = designation
        super.init(frame: .zero)
        self.createUI()
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
}

// MARK: - Publics
extension YZPinCodeNumPadView {
    
    public func updateBiometricAvailable(_ available: Bool) {
        self.biometricAvailable = available
        self.updateBiometricButton()
    }
}

// MARK: - Actions
extension YZPinCodeNumPadView {
    
    @objc private func roundButtonAction(sender: UIButton) {
        switch sender.tag {
        case 10:        self.showBiometricAlert()
        case 11:        self.delegate?.didTapPinCodeDelete(numPadView: self)
        case 0...9:     self.delegate?.didTapPinCodeNumber(sender.tag, numPadView: self)
        default:        break
        }
    }
    
    /// Update biometric type
    @objc private func updateBiometricType() {
        self.setBiometricType()
        self.updateBiometricButton()
    }
}

// MARK: - Private methods for CREATE UI
extension YZPinCodeNumPadView {
    
    //Create UI
    private func createUI() {
        self.backgroundColor = .clear
        
        self.setBiometricType()
        self.addObservers()
        self.createStackButtons()
        self.updateBiometricButton()
        self.showBiometricAlert()
    }
    
    /// Add observer
    private func addObservers() {
        NotificationCenter.default.addObserver(self, selector: #selector(updateBiometricType), name: UIApplication.didBecomeActiveNotification, object: nil)
    }
    
    /// Create stack buttons
    private func createStackButtons() {
        let verticalSpacing = self.designation?.getNumPadVerticalSpacing() ?? 16
        let stackView = self.createStackView(axis: .vertical, spacing: verticalSpacing)
        for _ in 0..<3 {
            let horizontalStackView = self.createButtonsStackView(buttonCount: 3)
            stackView.addArrangedSubview(horizontalStackView)
        }
        
        let pointZeroDeleteStackView = self.createBiometricAndDeleteAndZeroStackView()
        stackView.addArrangedSubview(pointZeroDeleteStackView)
        
        self.addSubview(stackView)
        let attributes: [NSLayoutConstraint.Attribute] = [.top, .left, .right, .bottom]
        stackView.translatesAutoresizingMaskIntoConstraints = false
        attributes.forEach {
            NSLayoutConstraint(item: stackView, attribute: $0, relatedBy: .equal, toItem: self, attribute: $0, multiplier: 1, constant: 0).isActive = true
        }
    }
    
    /// Create butons from 1 to 9
    private func createButtonsStackView(buttonCount: Int) -> UIStackView {
        let horizontalSpacing = self.designation?.getNumPadHorizontalSpacing() ?? 16
        let stackView = self.createStackView(axis: .horizontal, spacing: horizontalSpacing)
        for _ in 0..<buttonCount {
            let numButton = self.createRoundButton(title: "\(self.numTag)", tag: self.numTag)
            self.numTag += 1
            stackView.addArrangedSubview(numButton)
        }
        
        return stackView
    }
    
    /// Create stack view with options
    private func createStackView(axis: NSLayoutConstraint.Axis, spacing: CGFloat) -> UIStackView {
        let stackView = UIStackView()
        stackView.axis = axis
        stackView.distribution = UIStackView.Distribution.equalSpacing
        stackView.alignment = UIStackView.Alignment.center
        stackView.spacing = spacing
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        return stackView
    }
    
    /// Create Decimal separator, delete and zero button
    private func createBiometricAndDeleteAndZeroStackView() -> UIStackView {
        let horizontalSpacing = self.designation?.getNumPadHorizontalSpacing() ?? 16
        let stackView = self.createStackView(axis: .horizontal, spacing: horizontalSpacing)
        
        self.biometricButton = self.createRoundButton(image: self.designation?.getBiometricIcon(type: self.type), tag: 10)
        stackView.addArrangedSubview(self.biometricButton)
        stackView.addArrangedSubview(self.createRoundButton(title: "0", tag: 0))
        stackView.addArrangedSubview(self.createRoundButton(image: self.designation?.getDeleteIcon(), tag: 11))
        
        return stackView
    }
    
    /// Round button to show with number or other specific symbols
    private func createRoundButton(title: String, tag: Int) -> UIButton {
        let textColor = self.designation?.getNumPadTextColor() ?? .black
        let textFont = self.designation?.getNumPadTextFont() ?? UIFont.systemFont(ofSize: 17)
        let roundButton = self.createHightLightRoundButton()
        roundButton.addTarget(self, action: #selector(roundButtonAction), for: .touchUpInside)
        roundButton.tag = tag
        roundButton.setTitle(title, for: .normal)
        roundButton.setTitleColor(textColor, for: .normal)
        roundButton.titleLabel?.font = textFont
        
        return roundButton
    }
    
    /// Round button to show with number or other specific symbols
    private func createRoundButton(image: UIImage?, tag: Int) -> UIButton {
        let roundButton = self.createHightLightRoundButton()
        roundButton.addTarget(self, action: #selector(roundButtonAction), for: .touchUpInside)
        roundButton.tag = tag
        roundButton.setImage(image, for: .normal)
        
        return roundButton
    }
    
    /// Highlight round button
    private func createHightLightRoundButton() -> YZHightLightPinCodeRoundButton {
        let radius = self.designation?.getNumPadButtonRadius() ?? 22
        let borderColor = self.designation?.getNumPadButtonBorderColor() ?? .black
        let hightLightRoundButton = YZHightLightPinCodeRoundButton(backgroundColor: .clear,
                                                            radius: radius,
                                                            borderColor: borderColor,
                                                            borderWidth: 1)
        
        hightLightRoundButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint(item: hightLightRoundButton, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: (radius * 2)).isActive = true
        NSLayoutConstraint(item: hightLightRoundButton, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: (radius * 2)).isActive = true
        
        return hightLightRoundButton
    }
}

// MARK: - Private methods for UPDATE UI
extension YZPinCodeNumPadView {
    
    /// Update biometricButton
    private func updateBiometricButton() {
        let context = LAContext()
        if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: nil) {
            if self.type != .none && self.biometricAvailable {
                self.biometricButton.alpha = 1
                return
            }
        }
        
        self.biometricButton.alpha = 0
    }
    
    /// Update biometric type
    private func setBiometricType() {
        let context = LAContext()
        
        if #available(iOS 11.0, *) {
            context.canEvaluatePolicy(LAPolicy.deviceOwnerAuthenticationWithBiometrics, error: nil)
            switch context.biometryType {
            case .none:     self.type = .none
            case .touchID:  self.type = .touchID
            case .faceID:   self.type = .faceID
            @unknown default:   self.type = .none
            }
        } else {
            if context.canEvaluatePolicy(LAPolicy.deviceOwnerAuthenticationWithBiometrics, error: nil) {
                self.type = .touchID
            } else {
                self.type = .none
            }
        }
    }
}

// MARK: - Biometric
extension YZPinCodeNumPadView {
    
    /// Show Biometric alert
    private func showBiometricAlert() {
        guard self.type != .none && self.biometricAvailable else { return }
        guard let localizedReason = self.strings?.getAuthenticationReason() else { return }
        let context = LAContext()
        var error: NSError?
        
        if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) {
            context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: localizedReason) { [weak self] (success, evaluateError) in
                guard let strongSelf = self else { return }
                if success {
                    DispatchQueue.main.async {
                        strongSelf.delegate?.didBiometricSuccess(numPadView: strongSelf)
                    }
                } else {
                    if let evaluateError = evaluateError as NSError? {
                        DispatchQueue.main.async {
                            strongSelf.setBiometricType()
                            strongSelf.updateBiometricButton()
                            strongSelf.showErrorBiometricMessage(errorCode: evaluateError.code)
                        }
                    }
                }
            }
        }
    }
    
    private func showErrorBiometricMessage(errorCode: Int) {
        var message: String?
        switch errorCode {
        case LAError.appCancel.rawValue:
            message = self.strings?.getAppCancel()
            
        case LAError.authenticationFailed.rawValue:
            message = self.strings?.getAuthenticationFailed()
            
        case LAError.invalidContext.rawValue:
            message = self.strings?.getInvalidContext()
            
        case LAError.passcodeNotSet.rawValue:
            message = self.strings?.getPasscodeNotSet()
            
        case LAError.systemCancel.rawValue:
            message = self.strings?.getSystemCancel()
            
        case LAError.biometryLockout.rawValue:
            message = self.strings?.getBiometricLockOut()
            self.rootControllerDelegate?.showOkAlertController(message: message)
            
        case LAError.biometryNotAvailable.rawValue:
            message = self.strings?.getBiometricNotAvailable()
            
        case LAError.userCancel.rawValue:
            message = self.strings?.getUserCancel()
            
        case LAError.userFallback.rawValue:
            message = self.strings?.getUserFallback()
            
        default:
            message = self.strings?.getUndetectingErrorString()
        }
        
        if let m = message {
            print("YZPinCodeViewController biometric error message: \(m)")
        }
    }
}
