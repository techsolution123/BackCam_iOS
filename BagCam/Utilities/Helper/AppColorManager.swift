//
//  AppColorManager.swift
//  BagCam
//
//  Created by Kevin Shah on 12/02/21.
//

import UIKit

/// AppColorManager
class AppColorManager: NSObject {
    
    static var shared: AppColorManager = AppColorManager()
    
    var appBlack: UIColor = UIColor(named: "appBlack")!
    var appBlue: UIColor = UIColor(named: "appBlue")!
    var appGray: UIColor = UIColor(named: "appGray")!
    var appPlaceholder: UIColor = UIColor(named: "appPlaceholder")!
    var appRed: UIColor = UIColor(named: "appRed")!
    var appText: UIColor = UIColor(named: "appText")!
}
