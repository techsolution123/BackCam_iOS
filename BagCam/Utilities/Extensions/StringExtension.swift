//
//  Strig.swift
//  BagCam
//
//  Created by Pankaj Patel on 13/02/21.
//

import UIKit

let kAcceptableCharacters = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789_.-"

//MARK: - Character trimming
extension String {
    
    func trimming(newLine: Bool = false) -> String {
        if newLine {
            return trimmingCharacters(in: .whitespacesAndNewlines)
        }else{
             return trimmingCharacters(in: .whitespaces)
        }
    }
}

//MARK: - Searching
extension String {
    
    func contains(find: String) -> Bool{
        return range(of: find, options: .caseInsensitive) != nil
    }
}

//MARK: - Validation
extension String {

    var isNameValid: Bool {
        return !trimming(newLine: true).isEmpty && trimming(newLine: true).length > 2 && trimming(newLine: true).length < 20
    }
    
    var isPasswordValid: Bool {
//        let passwrordRegX = "^(?=.*[A-Z])(?=.*[!@#$&*])(?=.*[0-9])(?=.*[a-z]).{6,}$"
//        return NSPredicate(format: "SELF MATCHES %@", passwrordRegX).evaluate(with: self)
        return self.count >= 6
    }

    var isEmailAddressValid: Bool {
        let emailRegex = "^[A-Z0-9a-z][A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}$"
        return NSPredicate(format: "SELF MATCHES %@", emailRegex).evaluate(with: self)
    }
    
    var isUserNameContainSpecialCharacters: Bool {
        let characterset = CharacterSet(charactersIn: kAcceptableCharacters)
        return rangeOfCharacter(from: characterset.inverted) != nil //True, string contains special characters
    }
    
    var isUserNameValid: Bool {
        let cs = NSCharacterSet(charactersIn: kAcceptableCharacters).inverted
        let filtered = components(separatedBy: cs).joined(separator: "")
        return !trimming(newLine: true).isEmpty && trimming(newLine: true).length > 2 && trimming(newLine: true).length < 20 && self == filtered
    }
    
    var isUserNameEmailValid: Bool {
        if contains(find: "@") {
            return isEmailAddressValid
        }else{
            return isUserNameValid
        }
    }
    
    var isContactValid: Bool {
        let contactRegEx = "^[0-9]{7,15}$"
        let contactTest = NSPredicate(format:"SELF MATCHES %@", contactRegEx)
        return contactTest.evaluate(with: self)
    }
    
    static func validate(value:String?) -> Bool {
        if let string = value {
            return string.trimming(newLine: true).isEmpty
        }else{
            return false
        }
    }
}

//MARK: - Conversion
extension String {
    
    var doubleValue: Double? {
        return Double(self)
    }
    var floatValue: Float? {
        return Float(self)
    }
    var integerValue: Int? {
        return Int(self)
    }
    var int32Value: Int32? {
        return Int32(self)
    }
    var int64Value: Int64? {
        return Int64(self)
    }
}

//MARK: - Formatted
extension String {
    
    func strikeThroughLine(color: UIColor, textFont: UIFont, textColor: UIColor) -> NSAttributedString {
        let attributeString = NSMutableAttributedString(string: self)
        let range = NSMakeRange(0, attributeString.length)
        attributeString.addAttribute(.strikethroughStyle, value: NSNumber(integerLiteral: NSUnderlineStyle.single.rawValue), range: range)
        attributeString.addAttribute(.strikethroughColor, value: color, range: range)
        attributeString.addAttribute(.font, value: textFont, range: range)
        attributeString.addAttribute(.foregroundColor, value: textColor, range: range)
        return attributeString
    }

    func attributed(font: UIFont) -> NSAttributedString {
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.alignment = .justified
        
        let attributeString = NSMutableAttributedString(string: self)
        let str = NSString(string: self)
        let range = str.range(of: str as String)
        attributeString.addAttributes([.font: font], range: range)
        attributeString.addAttributes([.paragraphStyle : paragraphStyle], range: range)
        
        return attributeString
    }
    
    func addVerticalLine(space: CGFloat) -> NSAttributedString {
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = space
        paragraphStyle.alignment = .left

        let attributeString = NSMutableAttributedString(string: self)
        let range = NSMakeRange(0, attributeString.length)
        attributeString.addAttributes([.paragraphStyle : paragraphStyle], range: range)
        return attributeString
    }
    
    //It will add space between characters
    func characters(spacing:CGFloat) -> NSAttributedString {
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.alignment = .justified
        
        let attributedString = NSMutableAttributedString(string: self)
        let str = NSString(string: self)
        let range = str.range(of: str as String)
        attributedString.addAttribute(.kern, value: spacing, range: NSMakeRange(0, self.length))
        attributedString.addAttributes([.paragraphStyle : paragraphStyle], range: range)
        return attributedString
    }
    
    func justifiedAligned() -> NSAttributedString {
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.alignment = .justified
        
        let attributedString = NSMutableAttributedString(string: self)
        let str = NSString(string: self)
        let range = str.range(of: str as String)
        attributedString.addAttributes([.paragraphStyle : paragraphStyle], range: range)
        return attributedString
    }
    
    //Use for display First and Second characters of words.
    func initialWordFromCharacters() -> String {
        let components = self.components(separatedBy: " ")
        var strIntialCharacterWord = ""
        if !components.isEmpty{
            for component in components {
                if let firstCharacter = component.first {
                    strIntialCharacterWord += String(firstCharacter)
                }
            }
        }
        return strIntialCharacterWord.uppercased()
    }
    
    /// It will use to apply drop shadow effects to characters
    ///
    /// - Parameters:
    ///   - shadowOffset: Offset value in CGSize
    ///   - textColor: TextColor value in UIColor
    ///   - shadowColor: ShadowColor value in UIColor
    func addDropShadowToCharacters(_ xOffset: CGFloat = 0, yOffset: CGFloat = 0.5, textColor: UIColor, shadowColor: UIColor, shadowBlurRadius: CGFloat = 1) -> NSAttributedString {
        let shadow = NSShadow()
        shadow.shadowBlurRadius = shadowBlurRadius
        shadow.shadowColor = shadowColor
        shadow.shadowOffset = CGSize(width: xOffset, height: yOffset)
        
        let attributeString = NSMutableAttributedString(string: self)
        let range = NSMakeRange(0, attributeString.length)
        attributeString.addAttribute(.foregroundColor, value: textColor, range: range)
        attributeString.addAttribute(.shadow, value: shadow, range: range)
        return attributeString
    }
}

extension String {
    var length: Int {
        return (self as NSString).length
    }
}

//MARK: - Layout
extension String {
    
    func isEqual(str: String) -> Bool {
        if self.compare(str) == ComparisonResult.orderedSame{
            return true
        }else{
            return false
        }
    }
    
    func singleLineHeightFor(font: UIFont) -> CGFloat {
        let constraintRect = CGSize(width: CGFloat.greatestFiniteMagnitude, height: CGFloat.greatestFiniteMagnitude)
        let boundingBox = self.boundingRect(with: constraintRect, options: .usesLineFragmentOrigin, attributes: [.font: font], context: nil)
        return ceil(boundingBox.height)
    }
    
    func height(withConstrainedWidth width: CGFloat, font: UIFont) -> CGFloat {
        let constraintRect = CGSize(width: width, height: .greatestFiniteMagnitude)
        let boundingBox = self.boundingRect(with: constraintRect, options: [.usesDeviceMetrics, .truncatesLastVisibleLine, .usesFontLeading, .usesLineFragmentOrigin], attributes: [.font: font], context: nil)
        return boundingBox.height
    }
    
    func width(withConstrainedHeight height: CGFloat, font: UIFont) -> CGFloat {
        let constraintRect = CGSize(width: .greatestFiniteMagnitude, height: height)
        let boundingBox = self.boundingRect(with: constraintRect, options: .usesLineFragmentOrigin, attributes: [.font: font], context: nil)
        return boundingBox.width
    }
    
    func requiredHeight(width: CGFloat, font: UIFont,numberOfLines:Int = 0,lineBreakMode:NSLineBreakMode = .byWordWrapping) -> CGFloat {
        let label:UILabel = UILabel(frame: CGRect(x: 0, y: 0, width: width, height: CGFloat.greatestFiniteMagnitude))
        label.numberOfLines = numberOfLines
        label.lineBreakMode = lineBreakMode
        label.font = font
        label.text = self
        label.sizeToFit()
        return label.frame.height
    }
    
    func requiredWidth(font: UIFont) -> CGFloat {
        let label:UILabel = UILabel(frame: CGRect(x: 0, y: 0, width: CGFloat.greatestFiniteMagnitude, height: CGFloat.greatestFiniteMagnitude))
        label.numberOfLines = 1
        label.font = font
        label.text = self
        label.sizeToFit()
        return label.frame.width
    }
}

//MARK: - NSAttributedString
extension NSAttributedString {
    
    static func + (left: NSAttributedString, right: NSAttributedString) -> NSAttributedString {
        let result = NSMutableAttributedString()
        result.append(left)
        result.append(right)
        return result
    }
    
    func height(withConstrainedWidth width: CGFloat) -> CGFloat {
        let constraintRect = CGSize(width: width, height: .greatestFiniteMagnitude)
        let boundingBox = boundingRect(with: constraintRect, options: .usesLineFragmentOrigin, context: nil)
        return boundingBox.height
    }
    
    func width(withConstrainedHeight height: CGFloat) -> CGFloat {
        let constraintRect = CGSize(width: .greatestFiniteMagnitude, height: height)
        let boundingBox = boundingRect(with: constraintRect, options: .usesLineFragmentOrigin, context: nil)
        return boundingBox.width
    }
}
