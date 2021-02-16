//
//  UserInputFiledTableCell.swift
//  BagCam
//
//  Created by Kevin Shah on 12/02/21.
//

import UIKit

/// TintTextField
class TintTextField: UITextField {

    private var updatedClearImage = false

    override func layoutSubviews() {
        super.layoutSubviews()
        tintClearImage()
    }

    private func tintClearImage() {
        if updatedClearImage { return }

        if let button = self.value(forKey: "clearButton") as? UIButton,
            let image = button.image(for: .highlighted)?.withRenderingMode(.alwaysTemplate) {
            button.setImage(image, for: .normal)
            button.setImage(image, for: .highlighted)
            button.tintColor = AppColorManager.shared.appBlack

            updatedClearImage = true
        }
    }
}

/// UserInputFiledTableCell
class UserInputFiledTableCell: UITableViewCell {
    
    /// @IBOutlet(s)
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var tfInput: TintTextField!
    @IBOutlet weak var lblLine: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        /// assign textField delegate to self
        tfInput.delegate = self
        /// Add target to txtInputField
        tfInput.addTarget(self, action: #selector(textFieldDidEditingChange(_:)), for: .editingChanged)
    }
    
    /// Variable Declaration(s)
    weak var parentVC: ParentVC!
    var userInputFieldManager: UserInputFieldManager! {
        didSet {
            self.prepareDefaultFields()
            self.prepareInputFields()
        }
    }
    
    fileprivate func prepareDefaultFields() {
        let userInputField = userInputFieldManager.arrUserInputFieldModel[tag]
        lblTitle.text = userInputField.title
//        lblLine.backgroundColor = userInputField.lineColor
        tfInput.text = userInputField.text
        tfInput.placeholder = userInputField.placeholder
        tfInput.isSecureTextEntry = false
        tfInput.autocapitalizationType = .none
        tfInput.autocorrectionType = .no
        tfInput.spellCheckingType = .no
        tfInput.keyboardType = .default
        tfInput.keyboardAppearance = .default
        tfInput.returnKeyType = .next
        tfInput.tintColor = AppColorManager.shared.appBlack
        tfInput.textColor = AppColorManager.shared.appBlack
        tfInput.rightView = nil
        tfInput.rightViewMode = .never
        tfInput.inputView = nil
        tfInput.clearButtonMode = .whileEditing
        tfInput.isUserInteractionEnabled = true
    }
    
    fileprivate func textFieldRightView(_ imageName: String) {
        let rect = CGRect(origin: .zero, size: CGSize(width: 34, height: 30))
        let uiView: UIView = UIView(frame: rect)
        let imageView = UIImageView()
        imageView.image = UIImage(named: imageName)
        imageView.contentMode = .scaleAspectFit
        imageView.frame = rect
        imageView.tintColor = AppColorManager.shared.appBlack
        uiView.addSubview(imageView)
        imageView.frame = CGRect(origin: .zero, size: CGSize(width: 24, height: 24))
        imageView.center = uiView.center
        
        tfInput.rightViewMode = .always
        tfInput.rightView = uiView
        
        imageView.isUserInteractionEnabled = true
        
        let tapGesture: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.handleTap(_:)))
        imageView.addGestureRecognizer(tapGesture)
    }
    
    @objc func handleTap(_ gesture: UITapGestureRecognizer) {
        switch self.userInputFieldManager.type {
        case .login:
            if tag == 1 {
                tfInput.isSecureTextEntry = !tfInput.isSecureTextEntry
                let color = tfInput.isSecureTextEntry ? AppColorManager.shared.appBlack : AppColorManager.shared.appPlaceholder
                tfInput.rightView?.subviews.forEach({ (view) in
                    view.tintColor = color
                    view.subviews.forEach { (view) in
                        view.tintColor = color
                    }
                })
            }
        default:
            break
        }
    }
    
    fileprivate func prepareInputFields() {
        switch self.userInputFieldManager.type {
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
        default:
            break
        }
    }
    
    fileprivate func loginField() {
        if tag == 0 {
            tfInput.keyboardType = .emailAddress
            tfInput.textContentType = .emailAddress
        } else if tag == 1 {
            tfInput.isSecureTextEntry = true
            tfInput.textContentType = .password
            textFieldRightView("ic_faceId")
        }
    }
    
    fileprivate func signupField() {
        if tag == 0 {
            tfInput.keyboardType = .emailAddress
            tfInput.textContentType = .emailAddress
        } else if tag == 1 {
            tfInput.isSecureTextEntry = true
            tfInput.textContentType = .password
//            textFieldRightView("ic_faceId")
        } else if tag == 2 {
            tfInput.isSecureTextEntry = true
            tfInput.textContentType = .password
//            textFieldRightView("ic_faceId")
        }
    }
    
    fileprivate func forgotPasswordField() {
        if tag == 0 {
            tfInput.keyboardType = .emailAddress
            tfInput.textContentType = .emailAddress
        }
    }
    
    fileprivate func verifyCodeField() {
        if tag == 0 {
            tfInput.textContentType = .oneTimeCode
        }
    }
    
    fileprivate func resetPasswordField() {
        if tag == 0 {
            tfInput.isSecureTextEntry = true
            tfInput.textContentType = .password
//            textFieldRightView("ic_faceId")
        } else if tag == 1 {
            tfInput.isSecureTextEntry = true
            tfInput.textContentType = .password
//            textFieldRightView("ic_faceId")
        }
    }
}

// MARK: - UITextFieldDelegate
extension UserInputFiledTableCell: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    @objc func textFieldDidEditingChange(_ sender: UITextField) {
        if let text = sender.text {
            userInputFieldManager.arrUserInputFieldModel[tag].text = text
            userInputFieldManager.arrUserInputFieldModel[tag].isValid = userInputFieldManager.isValidData(tag)
            lblLine?.backgroundColor = userInputFieldManager.arrUserInputFieldModel[tag].lineColor
        }
    }
}
