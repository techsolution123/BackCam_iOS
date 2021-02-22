//
//  SuccessMessageType.swift
//  BagCam
//
//  Created by Kevin Shah on 17/02/21.
//

import UIKit

/// GeneralLabelInfoType
enum GeneralLabelInfoType {
    
    case accountCreated
    case devicePaired
    case addYourFirstDevice
    case holdPairing
    case availableDevices
    case selectBagCam
    
    var attStr: NSAttributedString? {
        switch self {
        case .accountCreated:
            let attStr: NSMutableAttributedString = NSMutableAttributedString()
            let imageAttr: NSAttributedString = NSAttributedString(attachment: NSTextAttachment(image: UIImage(systemName: "checkmark.circle.fill")!))
            attStr.append(imageAttr)
            let textAttr = NSAttributedString(string: " Account\nSuccessfully Created", attributes: [.font: AppFont.mabryProRegular.of(17), .foregroundColor: AppColorManager.shared.appBlue])
            attStr.append(textAttr)
            return attStr
        case .devicePaired:
            let attStr: NSMutableAttributedString = NSMutableAttributedString()
            let imageAttr: NSAttributedString = NSAttributedString(attachment: NSTextAttachment(image: UIImage(systemName: "checkmark.circle.fill")!))
            attStr.append(imageAttr)
            let textAttr = NSAttributedString(string: " Successfully Paired", attributes: [.font: AppFont.mabryProRegular.of(26), .foregroundColor: AppColorManager.shared.appBlue])
            attStr.append(textAttr)
            return attStr
        case .addYourFirstDevice:
            let attStr = NSAttributedString(string: "Add your first device", attributes: [.font: AppFont.mabryProRegular.of(26), .foregroundColor: AppColorManager.shared.appBlack])
            return attStr
        case .holdPairing:
            let attStr = NSAttributedString(string: "Hold pairing button on\nbag down for 3 seconds", attributes: [.font: AppFont.mabryProRegular.of(17), .foregroundColor: AppColorManager.shared.appText])
            return attStr
        case .availableDevices:
            let attStr = NSAttributedString(string: "Available Devices", attributes: [.font: AppFont.mabryProRegular.of(26), .foregroundColor: AppColorManager.shared.appBlack])
            return attStr
        case .selectBagCam:
            let attStr = NSAttributedString(string: "Please select the BagCam device that you would like to add", attributes: [.font: AppFont.mabryProRegular.of(17), .foregroundColor: AppColorManager.shared.appText])
            return attStr
        }
    }
}
