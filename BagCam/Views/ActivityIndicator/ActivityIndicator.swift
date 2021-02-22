//
//  ActivityIndicator.swift
//  XXSIM
//
//  Created by Kevin on 22/01/18.
//  Copyright © 2018 Kevin. All rights reserved.
//

import UIKit

class ActivityIndicator: UIView {

    // MARK: Outlets
    @IBOutlet var lblMessage: UILabel!
    @IBOutlet var actv: UIActivityIndicatorView!
    @IBOutlet var containerView: UIView!
    
    // MARK: Init
    class func intance(_ message: String = "") -> ActivityIndicator {
        let view = Bundle.main.loadNibNamed("ActivityIndicator", owner: nil, options: nil)![0] as! ActivityIndicator
        view.frame = CGRect(x: 0, y: 0, width: ScreenSize.width, height: ScreenSize.height)
        view.lblMessage.text = message
        view.layoutIfNeeded()
        return view
    }
    
    func show(_ message: String = "") { 
        self.frame = CGRect(x: 0, y: 0, width: ScreenSize.width, height: ScreenSize.height)
        self.lblMessage.text = message
        self.layoutIfNeeded()
        self.actv.startAnimating()
    }
    
    func hide(){
        self.actv.stopAnimating()
        self.removeFromSuperview()
    }
    
    func msgWidth(message msg:String) -> CGFloat{
        let width = msg.requiredWidth(font: UIFont.systemFont(ofSize: 14 * ScreenSize.widthRatio, weight: .bold))
        return min(ScreenSize.height - 80, width)
    }
    
    func msgHeight(message msg:String) -> CGFloat {
        let width = msgWidth(message: msg)
        let height = msg.requiredHeight(width: width, font: UIFont.systemFont(ofSize: 14 * ScreenSize.widthRatio, weight: .bold))
        return max(80, height + height + 28)
    }

}
