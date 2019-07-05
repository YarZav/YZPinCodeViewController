//
//  YZPinCodeViewController.swift
//  MoneyKeeper
//
//  Created by Yaroslav Zavyalov on 03/07/2019.
//  Copyright © 2019 ZYG. All rights reserved.
//

import UIKit
import AudioToolbox

// MARK: - Pin code view controller
class YZPinCodeViewController: UIViewController {
    
    public var viewType: YZPinCodeType = .create
    public var biometricAvalable: Bool = false
    public weak var strings: YZPinCodeBiometricStrings?
    public weak var delegate: YZPinCodeDelegate?
    public weak var designation: YZPinCodeViewControllerDesignation?
    
    private var titleLabel = UILabel()
    private var circlesView = UIView()
    private weak var numPadView: YZPinCodeNumPadView?
    
    private var pinCode: String = ""
    private var newPinCode: String = ""
    private var errorTimer: Timer?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.createUI()
    }
    
    /// Hide tab bar
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.tabBarController?.tabBar.isHidden = true
    }
    
    /// Show tab bar
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        self.tabBarController?.tabBar.isHidden = false
    }
}

// MARK: - Actions
extension YZPinCodeViewController {
    
    @objc private func backAction() {
        if self.isModalViewController() {
            self.dismiss(animated: false, completion: nil)
        } else {
            self.navigationController?.popViewController(animated: true)
        }
    }
    
    /// Is YZPinCodeViewController as modale view controller
    private func isModalViewController() -> Bool {
        let presentingIsModal = self.presentingViewController != nil
        let presentingIsNavigation = self.navigationController?.presentingViewController?.presentedViewController == navigationController
        let presentingIsTabBar = self.tabBarController?.presentingViewController is UITabBarController
        return presentingIsModal || presentingIsNavigation || presentingIsTabBar
    }
}

// MARK: - Privates, CREATE UI
extension YZPinCodeViewController {
    
    /// Create UI
    private func createUI () {
        guard let designation = self.designation else {
            fatalError("Set 'designations' delegate to get UI constants")
        }
        
        self.view.backgroundColor = self.designation?.getBackgroundColor()
        self.createBackButton()
        self.createTitleLabel(designation: designation)
        self.createCircleViews(designation: designation)
        self.createNumPadView()
    }
    
    /// Create back button
    private func createBackButton() {
        self.navigationItem.hidesBackButton = true
        let imageOrTitle = self.designation?.getBackButtonImageOrTitle()
        
        var backButton: UIBarButtonItem?
        if let title = imageOrTitle as? String {
            backButton = UIBarButtonItem(title: title, style: .plain, target: self, action: #selector(backAction))
        }
        
        if let image = imageOrTitle as? UIImage {
            backButton = UIBarButtonItem(image: image, style: .plain, target: self, action: #selector(backAction))
        }
        
        self.navigationItem.leftBarButtonItem = backButton
    }
    
    /// Create Top title label
    private func createTitleLabel(designation: YZPinCodeViewControllerDesignation) {
        self.titleLabel.textAlignment = .center
        self.titleLabel.textColor = designation.getTitleColor()
        self.titleLabel.text = designation.getTitleText(for: self.viewType)
       
        self.view.addSubview(self.titleLabel)
        self.titleLabel.translatesAutoresizingMaskIntoConstraints = false
        let topOffset: CGFloat
        if let navigationController = self.navigationController, navigationController.navigationBar.isTranslucent {
            topOffset = 60
        } else {
            topOffset = 16
        }
        NSLayoutConstraint(item: self.titleLabel, attribute: .top, relatedBy: .equal, toItem: self.view, attribute: .top, multiplier: 1, constant: topOffset).isActive = true
        NSLayoutConstraint(item: self.titleLabel, attribute: .left, relatedBy: .equal, toItem: self.view, attribute: .left, multiplier: 1, constant: 16).isActive = true
        NSLayoutConstraint(item: self.titleLabel, attribute: .right, relatedBy: .equal, toItem: self.view, attribute: .right, multiplier: 1, constant: -16).isActive = true
    }
    
    /// Create sircle views
    private func createCircleViews(designation: YZPinCodeViewControllerDesignation) {
        let pinCodeLength = designation.getPinCodeLength()
        let circleRadius = designation.getCircleRadius()
        
        self.view.addSubview(self.circlesView)
        self.circlesView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint(item: self.circlesView, attribute: .top, relatedBy: .equal, toItem: self.titleLabel, attribute: .bottom, multiplier: 1, constant: 16).isActive = true
        NSLayoutConstraint(item: self.circlesView, attribute: .centerX, relatedBy: .equal, toItem: self.view, attribute: .centerX, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: self.circlesView, attribute: .left, relatedBy: .greaterThanOrEqual, toItem: self.view, attribute: .left, multiplier: 1, constant: 16).isActive = true
        NSLayoutConstraint(item: self.circlesView, attribute: .right, relatedBy: .lessThanOrEqual, toItem: self.view, attribute: .right, multiplier: 1, constant: -16).isActive = true
        NSLayoutConstraint(item: self.circlesView, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: circleRadius * 2).isActive = true
        
        let circleColor = designation.getCircleColor()
        var prevCircleView: UIView?
        for i in 0..<pinCodeLength {
            let circleView = UIView()
            circleView.backgroundColor = self.view.backgroundColor
            circleView.layer.masksToBounds = true
            circleView.layer.borderWidth = 1
            circleView.layer.borderColor = circleColor.cgColor
            circleView.layer.cornerRadius = circleRadius
            
            self.circlesView.addSubview(circleView)
            circleView.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint(item: circleView, attribute: .top, relatedBy: .equal, toItem: self.circlesView, attribute: .top, multiplier: 1, constant: 0).isActive = true
            NSLayoutConstraint(item: circleView, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: circleRadius * 2).isActive = true
            NSLayoutConstraint(item: circleView, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: circleRadius * 2).isActive = true
            
            if let prevView = prevCircleView {
                NSLayoutConstraint(item: circleView, attribute: .left, relatedBy: .equal, toItem: prevView, attribute: .right, multiplier: 1, constant: 16).isActive = true
            } else {
                NSLayoutConstraint(item: circleView, attribute: .left, relatedBy: .equal, toItem: self.circlesView, attribute: .left, multiplier: 1, constant: 0).isActive = true
            }
            
            if i == (pinCodeLength - 1) {
                NSLayoutConstraint(item: circleView, attribute: .right, relatedBy: .equal, toItem: self.circlesView, attribute: .right, multiplier: 1, constant: 0).isActive = true
            }
            
            prevCircleView = circleView
        }
    }
    
    /// Create num pad view
    private func createNumPadView() {
        if self.viewType == .create || self.viewType == .confirm {
            self.biometricAvalable = false
        }
        
        let numPadView = YZPinCodeNumPadView(delegate: self, designation: self.designation, strings: self.strings, biometricAvailable: self.biometricAvalable)
        numPadView.rootControllerDelegate = self
        self.numPadView = numPadView

        self.view.addSubview(numPadView)
        numPadView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint(item: numPadView, attribute: .top, relatedBy: .equal, toItem: self.circlesView, attribute: .bottom, multiplier: 1, constant: 16).isActive = true
        NSLayoutConstraint(item: numPadView, attribute: .left, relatedBy: .equal, toItem: self.view, attribute: .left, multiplier: 1, constant: 16).isActive = true
        NSLayoutConstraint(item: numPadView, attribute: .right, relatedBy: .equal, toItem: self.view, attribute: .right, multiplier: 1, constant: -16).isActive = true
    }
    
    /// Create error view
    private func createErrorView(_ errorText: String) -> YZPinCodeErrorView {
        let errorView = YZPinCodeErrorView()
        errorView.tag = 4567
        errorView.displayError(errorText)
        errorView.alpha = 0
        
        self.view.addSubview(errorView)
        errorView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint(item: errorView, attribute: .bottom, relatedBy: .equal, toItem: self.view, attribute: .bottom, multiplier: 1, constant: -16).isActive = true
        NSLayoutConstraint(item: errorView, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 44).isActive = true
        NSLayoutConstraint(item: errorView, attribute: .left, relatedBy: .equal, toItem: self.view, attribute: .left, multiplier: 1, constant: 16).isActive = true
        NSLayoutConstraint(item: errorView, attribute: .right, relatedBy: .equal, toItem: self.view, attribute: .right, multiplier: 1, constant: -16).isActive = true
        
        return errorView
    }
}

// MARK: - Privates, UPDATE UI
extension YZPinCodeViewController {
    
    /// Update UI pin code circles
    private func updateCircleViews(delete: Bool) {
        let updatedIndex = self.pinCode.count - (delete ? 0 : 1)
        
        if self.circlesView.subviews.indices.contains(updatedIndex) {
            let circleView = self.circlesView.subviews[updatedIndex]
            self.redrawCircleView(circleView, delete: delete)
        }
    }
    
    /// Redraw all circle views
    private func resetCirclesView() {
        self.circlesView.subviews.forEach {
            $0.backgroundColor = self.view.backgroundColor
        }
    }
    
    /// Redraw circle view
    private func redrawCircleView(_ view: UIView, delete: Bool) {
        if delete {
            view.backgroundColor = self.view.backgroundColor
        } else {
            view.backgroundColor = self.designation?.getCircleColor()
        }
    }
    
    private func updateUI() {
        self.view.isUserInteractionEnabled = false
        
        Timer.scheduledTimer(withTimeInterval: 0.15, repeats: false) { (timer) in
            self.view.isUserInteractionEnabled = true

            self.pinCode = ""
            self.newPinCode = ""
            self.resetCirclesView()
            self.titleLabel.text = self.designation?.getTitleText(for: self.viewType)
            
            switch self.viewType {
            case .create, .confirm:
                self.numPadView?.updateBiometricAvailable(false)
                
            case .delete, .change, .enter:
                self.numPadView?.updateBiometricAvailable(self.biometricAvalable)
            }
        }
    }
    
    private func failedPinCode() {
        AudioServicesPlayAlertSound(kSystemSoundID_Vibrate)
        self.updateUI()
        
        if self.viewType == .delete || self.viewType == .change || self.viewType == .enter {
            self.showFailedView()
        }
    }
    
    private func showFailedView() {
        guard let errorText = self.designation?.getErrorString() else { return }
        
        if let errorView = self.view.viewWithTag(4567) as? YZPinCodeErrorView {
            self.errorTimer?.invalidate()
            self.errorTimer = nil
            errorView.displayError(errorText)
            self.startErrorTimer(errorView)
        } else {
            let errorView = self.createErrorView(errorText)
            
            UIView.animate(withDuration: 0.15, animations: {
                errorView.alpha = 1
            }) { (completed) in
                if completed {
                    self.startErrorTimer(errorView)
                }
            }
        }
    }
    
    private func startErrorTimer(_ failedView: YZPinCodeErrorView) {
        self.errorTimer = Timer.scheduledTimer(withTimeInterval: 2, repeats: false, block: { [weak self] (timer) in
            guard let strongSelf = self else { return }
            strongSelf.hideFailedView(failedView)
        })
    }
    
    private func hideFailedView(_ failedView: YZPinCodeErrorView) {
        UIView.animate(withDuration: 0.15, animations: {
            failedView.alpha = 0
        }) { (completed) in
            if completed {
                failedView.removeFromSuperview()
            }
        }
    }
}

// MARK: - Do view type actions
extension YZPinCodeViewController {
    
    /// Create pin code
    private func createPinCode() {
        self.newPinCode = self.pinCode
        self.viewType = .confirm
        self.updateUI()
    }
    
    /// Confirm pin code
    private func confirmPinCode() {
        if self.newPinCode == self.pinCode {
            self.delegate?.createPinCode(self.pinCode, from: self)
            self.backAction()
        } else {
            self.viewType = .create
            self.failedPinCode()
        }
    }
    
    /// Delete pin code
    private func deletePinCode() {
        if self.delegate?.validatePinCode(self.pinCode, from: self) ?? false {
            self.delegate?.deletePinCode(from: self)
            self.backAction()
        } else {
            self.failedPinCode()
        }
    }
    
    /// Change pin code
    private func changePinCode() {
        if self.delegate?.validatePinCode(self.pinCode, from: self) ?? false {
            self.viewType = .create
            self.updateUI()
        } else {
            self.failedPinCode()
        }
    }
    
    /// Enter pin code
    private func enterPinCode() {
        if self.delegate?.validatePinCode(self.pinCode, from: self) ?? false {
            self.backAction()
        } else {
            self.failedPinCode()
        }
    }
}

// MARK: - YZPinCodeNumPadViewDelegate
extension YZPinCodeViewController: YZPinCodeNumPadViewDelegate {
    
    func didTapPinCodeNumber(_ number: Int, numPadView: YZPinCodeNumPadView) {
        let pinCodeLength = self.designation?.getPinCodeLength() ?? 0
        if  self.pinCode.count < pinCodeLength {
            self.pinCode += "\(number)"
            self.updateCircleViews(delete: false)
        }
        
        if self.pinCode.count == pinCodeLength {
            switch self.viewType {
            case .create:   self.createPinCode()
            case .confirm:  self.confirmPinCode()
            case .delete:   self.deletePinCode()
            case .change:   self.changePinCode()
            case .enter:    self.enterPinCode()
            }
        }
    }
    
    func didBiometricSuccess(numPadView: YZPinCodeNumPadView) {
        switch self.viewType {
        case .create, .confirm:
            break
            
        case .delete:
            self.delegate?.deletePinCode(from: self)
            self.backAction()
            
        case .change:
            self.viewType = .create
            self.updateUI()
            
        case .enter:
            self.backAction()
        }
    }
    
    func didTapPinCodeDelete(numPadView: YZPinCodeNumPadView) {
        if !self.pinCode.isEmpty {
            self.pinCode.removeLast()
            self.updateCircleViews(delete: true)
        }
    }
}

// MARK: - YZPinCodeRootController
extension YZPinCodeViewController: YZPinCodeRootController {
    
    func showOkAlertController(message: String?) {
        let alertController = UIAlertController(title: message, message: nil, preferredStyle: .alert)
        let okButton = UIAlertAction(title: "Ok", style: .cancel) { (action) in
            alertController.dismiss(animated: false, completion: nil)
        }
        alertController.addAction(okButton)
        self.present(alertController, animated: false, completion: nil)
    }
}

