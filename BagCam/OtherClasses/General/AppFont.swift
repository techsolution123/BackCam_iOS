//
//  AppFont.swift
//  BagCam
//
//  Created by Kevin Shah on 13/02/21.
//

import UIKit

/// AppFont
enum AppFont: String {
    
//        Font Family Name = [Gascogne-Regular]
//        Font Names = [["Gascogne-Regular"]]
//
//        Font Family Name = [Mabry Pro]
//        Font Names = [["MabryPro-Regular", "MabryPro-Medium"]]
//
//        Font Family Name = [Pherome]
//        Font Names = [["font0000000025d7cd1a"]]
    
    case gasconeRegular = "Gascogne-Regular"
    case mabryProRegular = "MabryPro-Regular"
    case mabryProMedium = "MabryPro-Medium"
    
    func of(_ size: CGFloat) -> UIFont {
        return UIFont(name: self.rawValue, size: size)!
    }
}
