//
//  AppFont.swift
//  BagCam
//
//  Created by Kevin Shah on 13/02/21.
//

import UIKit

/// AppFont
enum AppFont: String {
    
    case gasconeRegular = "Gascogne-Regular"
    case mabryProRegular = "MabryPro-Regular"
    case mabryProMedium = "MabryPro-Medium"
    case pheromeRegular = "Pherome"
    
    func of(_ size: CGFloat) -> UIFont {
        return UIFont(name: self.rawValue, size: size)!
    }
}
