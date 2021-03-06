//
//  UserInputFieldManager.swift
//  BagCam
//
//  Created by Kevin Shah on 12/02/21.
//

import UIKit

/// UserInputFieldType
enum UserInputFieldType {
    case login
    case signup
    case forgotPassword
    case verifyCode
    case resetPassword
    
    var titleAttr: NSAttributedString? {
        switch self {
        case .login:
            let attStr: NSAttributedString = NSAttributedString(string: "Welcome back,\nsign in.", attributes: [.font: AppFont.pheromeRegular.of(45)])
            return attStr
        case .signup:
            let attStr: NSAttributedString = NSAttributedString(string: "Hey there,\nsign up.", attributes: [.font: AppFont.pheromeRegular.of(45)])
            return attStr
        case .forgotPassword:
            let attStr: NSMutableAttributedString = NSMutableAttributedString(string: "Password\nRecovery.", attributes: [.font: AppFont.pheromeRegular.of(45)])

            let subAttStr: NSAttributedString = NSAttributedString(string: "\n\nPlease enter your email address and we will send you an email with further instructions to reset your password.", attributes: [.font: AppFont.mabryProRegular.of(17)])
            attStr.append(subAttStr)
            return attStr
        case .verifyCode:
            let attStr: NSAttributedString = NSAttributedString(string: "Please enter the security code generated by your mobile authenticator app.", attributes: [.font: AppFont.mabryProRegular.of(17)])
            return attStr
        case .resetPassword:
            let attStr: NSAttributedString = NSAttributedString(string: "Reset\nPassword.", attributes: [.font: AppFont.pheromeRegular.of(45)])
            return attStr
        }
    }
}

/// UserInputFieldModel
class UserInputFieldModel: NSObject {
    
    var title: String = ""
    var placeholder: String = ""
    var text: String = ""
    var webKey: String = ""
    var isValid: Bool = true
    var errorMessage: String = ""
    
    var lineColor: UIColor {
        return isValid ? AppColorManager.shared.appBlack : AppColorManager.shared.appRed
    }
}

/// UserInputFieldManager
class UserInputFieldManager: NSObject {
    
    /// Variable Declaration(s)
    var arrUserInputFieldModel: [UserInputFieldModel] = []
    var type: UserInputFieldType = .login
    
    init(_ type: UserInputFieldType) {
        self.type = type
        super.init()
        self.prepareUserInputFieldData()
    }
    
    fileprivate func prepareUserInputFieldData() {
        switch self.type {
        case .login:
            self.loginField()
        case .signup:
            self.signupField()
        case .forgotPassword:
            self.forgotPasswordField()
        case .verifyCode:
            self.verifyCodeField()
        case .resetPassword:
            self.resetPasswordField()
        }
    }
    
    fileprivate func loginField() {
        let inputField1 = UserInputFieldModel()
        inputField1.title = "Email Address".uppercased()
        inputField1.placeholder = "user@bagcam.com"
        inputField1.webKey = "email"
        
        let inputField2 = UserInputFieldModel()
        inputField2.title = "Password".uppercased()
        inputField2.placeholder = "123456"
        inputField2.webKey = "password"
        
        self.arrUserInputFieldModel = [inputField1, inputField2]
    }
    
    fileprivate func signupField() {
        let inputField1 = UserInputFieldModel()
        inputField1.title = "Email Address".uppercased()
        inputField1.placeholder = "user@bagcam.com"
        inputField1.webKey = "email"
        
        let inputField2 = UserInputFieldModel()
        inputField2.title = "Password".uppercased()
        inputField2.placeholder = "123456"
        inputField2.webKey = "password"
        
        let inputField3 = UserInputFieldModel()
        inputField3.title = "Retype Password".uppercased()
        inputField3.placeholder = "123456"
        inputField3.webKey = "c_password"
        
        self.arrUserInputFieldModel = [inputField1, inputField2, inputField3]
    }
    
    fileprivate func forgotPasswordField() {
        let inputField1 = UserInputFieldModel()
        inputField1.title = "Email Address".uppercased()
        inputField1.placeholder = "user@bagcam.com"
        inputField1.webKey = "email"
        
        self.arrUserInputFieldModel = [inputField1]
    }
    
    fileprivate func verifyCodeField() {
        let inputField1 = UserInputFieldModel()
        inputField1.title = "Code".uppercased()
        inputField1.placeholder = "6-digit code"
        inputField1.webKey = "code"
        
        self.arrUserInputFieldModel = [inputField1]
    }
    
    fileprivate func resetPasswordField() {
        let inputField1 = UserInputFieldModel()
        inputField1.title = "New Password".uppercased()
        inputField1.placeholder = "123456"
        inputField1.webKey = "password"
        
        let inputField2 = UserInputFieldModel()
        inputField2.title = "Confirm New Password".uppercased()
        inputField2.placeholder = "123456"
        inputField2.webKey = ""
        
        self.arrUserInputFieldModel = [inputField1, inputField2]
    }
}

// MARK: - Other Method(s)
extension UserInputFieldManager {
    
    func paramDict() -> [String : Any] {
        var dictParam = [String: Any]()
        arrUserInputFieldModel.forEach { (inputField) in
            if !inputField.webKey.isEmpty {
                dictParam[inputField.webKey] = inputField.text.trimmingCharacters(in: .whitespacesAndNewlines)
            }
        }
        return dictParam
    }
    
    func isValidData() -> (index: Int, valid: Bool, error: String) {
        var result = (index: 0, valid: true, error: "")
        switch type {
        case .login:
            if String.validate(value: arrUserInputFieldModel[0].text) {
                result.index = 0
                result.valid = false
                result.error = kEnterEmail
                return result
            } else if !arrUserInputFieldModel[0].text.isEmailAddressValid {
                result.index = 0
                result.valid = false
                result.error = kEnterValidEmail
                return result
            } else if String.validate(value: arrUserInputFieldModel[1].text) {
                result.index = 1
                result.valid = false
                result.error = kEnterPassword
                return result
            } else if !arrUserInputFieldModel[1].text.isPasswordValid {
                result.index = 1
                result.valid = false
                result.error = kEnterValidPassword
                return result
            }
        case .signup:
            if String.validate(value: arrUserInputFieldModel[0].text) {
                result.index = 0
                result.valid = false
                result.error = kEnterEmail
                return result
            } else if !arrUserInputFieldModel[0].text.isEmailAddressValid {
                result.index = 0
                result.valid = false
                result.error = kEnterValidEmail
                return result
            } else if String.validate(value: arrUserInputFieldModel[1].text) {
                result.index = 1
                result.valid = false
                result.error = kEnterPassword
                return result
            } else if !arrUserInputFieldModel[1].text.isPasswordValid {
                result.index = 1
                result.valid = false
                result.error = kEnterValidPassword
                return result
            } else if String.validate(value: arrUserInputFieldModel[2].text) {
                result.index = 2
                result.valid = false
                result.error = kEnterConfirmPassword
                return result
            } else if !arrUserInputFieldModel[2].text.isPasswordValid {
                result.index = 2
                result.valid = false
                result.error = kEnterValidPassword
                return result
            } else if arrUserInputFieldModel[1].text != arrUserInputFieldModel[2].text {
                result.index = 2
                result.valid = false
                result.error = kEnterPasswordNotMatched
                return result
            }
        case .forgotPassword:
            if String.validate(value: arrUserInputFieldModel[0].text) {
                result.index = 0
                result.valid = false
                result.error = kEnterEmail
                return result
            } else if !arrUserInputFieldModel[0].text.isEmailAddressValid {
                result.index = 0
                result.valid = false
                result.error = kEnterValidEmail
                return result
            }
        case .verifyCode:
            if String.validate(value: arrUserInputFieldModel[0].text) {
                result.index = 0
                result.valid = false
                result.error = kEnterVerficationCode
                return result
            }
        case .resetPassword:
            if String.validate(value: arrUserInputFieldModel[0].text) {
                result.index = 0
                result.valid = false
                result.error = kEnterPassword
                return result
            } else if !arrUserInputFieldModel[0].text.isPasswordValid {
                result.index = 0
                result.valid = false
                result.error = kEnterValidPassword
                return result
            } else if String.validate(value: arrUserInputFieldModel[1].text) {
                result.index = 1
                result.valid = false
                result.error = kEnterConfirmPassword
                return result
            } else if !arrUserInputFieldModel[1].text.isPasswordValid {
                result.index = 1
                result.valid = false
                result.error = kEnterValidPassword
                return result
            } else if arrUserInputFieldModel[0].text != arrUserInputFieldModel[1].text {
                result.index = 1
                result.valid = false
                result.error = kEnterPasswordNotMatched
                return result
            }
        }
        return result
    }
}
