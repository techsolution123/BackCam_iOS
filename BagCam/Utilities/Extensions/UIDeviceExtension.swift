//
//  UIDeviceExtension.swift
//  BagCam
//
//  Created by Pankaj Patel on 16/02/21.
//

import UIKit

/// ScreenSize
class ScreenSize: NSObject {
    
    static let width = UIScreen.main.bounds.size.width
    static let height = UIScreen.main.bounds.size.height
    static let frame = UIScreen.main.bounds
    static let maxLength = max(width, height)
    static let minLength = min(width, height)
    
    @objc class var widthRatio: CGFloat {
        return width / 375
    }
    
    @objc class var heightRatio: CGFloat {
        return height / 812
    }
}
