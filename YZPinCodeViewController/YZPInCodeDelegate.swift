//
//  YZPInCodeDelegate.swift
//  MoneyKeeper
//
//  Created by Yaroslav Zavyalov on 04/07/2019.
//  Copyright © 2019 ZYG. All rights reserved.
//

import UIKit

/// YZPinCodeViewController
/// Delegates for pin code controller which used contains types, strings, designation, actions

/// States of pin code viw controller
enum YZPinCodeType: Int {
    
    /// Create new pin code
    case create = 0
    
    /// Confirm new pin code
    case confirm = 1
    
    /// Delete current pin code
    case delete = 2
    
    /// Change current pin code
    case change = 3
    
    /// Enter pin code when start application
    case enter = 4
}

/// Designation delegate for UI
protocol YZPinCodeViewControllerDesignation: YZPinCodeNumPadViewDesignation {
    
    /// Get back button
    func getBackButtonImageOrTitle() -> Any?
    
    /// Background color for UIViewController
    func getBackgroundColor() -> UIColor
    
    /// Title color for UILabel
    func getTitleColor() -> UIColor
    
    /// Title text for UILabel
    func getTitleText(for type: YZPinCodeType) -> String?
    
    /// Pin code length
    func getPinCodeLength() -> Int
    
    /// Circle color
    func getCircleColor() -> UIColor
    
    /// Circle radius
    func getCircleRadius() -> CGFloat
    
    /// Get error string, when attempt was failed
    func getErrorString() -> String
    
    /// Get forgot button text color
    func getForgotButtonTextColor() -> UIColor
    
    /// Get forgot button text
    func getForgotButtonText() -> String
}

extension YZPinCodeViewControllerDesignation {
    
    /// Default title color for UILabel is white
    func getTitleColor() -> UIColor {
        return .white
    }
    
    /// Default pin code length is 4 numbers
    func getPinCodeLength() -> Int {
        return 4
    }
    
    /// Default circle color is white
    func getCircleColor() -> UIColor {
        return .white
    }
    
    /// Default circle radius is 10
    func getCircleRadius() -> CGFloat {
        return 10
    }
    
    /// Get forgot button text color
    func getForgotButtonTextColor() -> UIColor {
        return .white
    }
}

/// Actions from YZPinCodeViewController
protocol YZPinCodeDelegate: class {
    
    /// When created new pin code for application
    func createPinCode(_ pinCode: String, from controller: YZPinCodeViewController)
    
    /// When deleted current pin code for application
    func deletePinCode(from controller: YZPinCodeViewController)
    
    /// Is pin code equal current pin code for application
    func validatePinCode(_ pinCode: String, from controller: YZPinCodeViewController) -> Bool
}

/// YZPinCodeNumPadView
/// Biometric types, delegate etc

/// Biometric type
public enum YZPinCodeBiometricType: Int {
    
    /// Biometric not available
    case none = 0
    
    /// Biometric is TouchID
    case touchID = 1
    
    /// Biometric is FaceID
    case faceID = 2
}

/// Pin code number pad actions
public protocol YZPinCodeNumPadViewDelegate: class {
    
    /// Tap number button in number pad
    func didTapPinCodeNumber(_ number: Int, numPadView: YZPinCodeNumPadView)
    
    /// Biometric scan was success
    func didBiometricSuccess(numPadView: YZPinCodeNumPadView)
    
    /// Delete last number
    func didTapPinCodeDelete(numPadView: YZPinCodeNumPadView)
}

/// Desination delefate for pin code number pad
public protocol YZPinCodeNumPadViewDesignation: class {
    
    /// Get horizontal spacing between buttons
    func getNumPadHorizontalSpacing() -> CGFloat
    
    /// Get vertical spacing between buttons
    func getNumPadVerticalSpacing() -> CGFloat
    
    /// Get delete icon
    func getDeleteIcon() -> UIImage?
    
    /// Get biomatric icon
    func getBiometricIcon(type: YZPinCodeBiometricType) -> UIImage?
    
    /// Get button text color
    func getNumPadTextColor() -> UIColor
    
    /// Get button text font
    func getNumPadTextFont() -> UIFont
    
    /// Get button radius
    func getNumPadButtonRadius() -> CGFloat
    
    /// Get button border color
    func getNumPadButtonBorderColor() -> UIColor
}

/// Default values for number pad designation
extension YZPinCodeNumPadViewDesignation {
    
    /// Default space between buttons by horizontal on number pad is 20
    func getNumPadHorizontalSpacing() -> CGFloat {
        return 20
    }
    
    /// Default space between buttons by vertical ob number pad is 16
    func getNumPadVerticalSpacing() -> CGFloat {
        return 16
    }
    
    /// Default text color for buttons in number pad is white
    func getNumPadTextColor() -> UIColor {
        return .white
    }
    
    /// Default text font for buttons in number pad is 35, thin
    func getNumPadTextFont() -> UIFont {
        return UIFont.systemFont(ofSize: 35, weight: .thin)
    }
    
    /// Default radius for buttons in number pad is 35
    func getNumPadButtonRadius() -> CGFloat {
        return 35
    }
    
    /// Default corder color for buttons in number pad is white
    func getNumPadButtonBorderColor() -> UIColor {
        return .white
    }
}

// Connect pin code number pad view (YZPinCodeNumPadView) and pin code viewController (YZPinCodeViewController)
protocol YZPinCodeRootController: class {
    
    /// Show Ok view controller
    func showOkAlertController(message: String?)
}

/// Pin code number pad strings
public protocol YZPinCodeBiometricStrings: class {
    
    /// LAError.appCancel
    func getAuthenticationReason() -> String?
    
    /// LAError.authenticationFailed
    func getAppCancel() -> String?
    
    /// LAError.invalidContext
    func getAuthenticationFailed() -> String?
    
    /// LAError.passcodeNotSet
    func getInvalidContext() -> String?
    
    /// LAError.passcodeNotSet
    func getPasscodeNotSet() -> String?
    
    /// LAError.systemCancel
    func getSystemCancel() -> String?
    
    /// LAError.biometryLockout
    func getBiometricLockOut() -> String?
    
    /// LAError.biometryNotAvailable
    func getBiometricNotAvailable() -> String?
    
    /// LAError.userCancel
    func getUserCancel() -> String?
    
    /// LAError.userFallback
    func getUserFallback() -> String?
    
    /// Default error message
    func getUndetectingErrorString() -> String?
}
