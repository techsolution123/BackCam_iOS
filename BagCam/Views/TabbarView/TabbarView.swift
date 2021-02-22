//
//  TabbarView.swift
//  BagCam
//
//  Created by Kevin Shah on 18/02/21.
//

import UIKit

/// TabbarView
class TabbarView: UIView {
    
    /// @IBOutlet(s)
    @IBOutlet weak var lblSlider: UILabel!
    @IBOutlet var arrBtn: [UIButton]!
    
    /// Constraint(s)
    @IBOutlet weak var lblSliderLeadingConstraint: NSLayoutConstraint!
    
    /// Variable Declaration(s)
    var selectionCompletion: ((Int) -> ())?
    
    func animateSlider(_ index: Int) {
        self.selectionCompletion?(index)
        self.arrBtn.forEach { (button) in
            button.isSelected = false
        }
        self.arrBtn[index].isSelected = true
        let xPoint: CGFloat = self.lblSlider.frame.size.width * CGFloat(index)
        UIView.animate(withDuration: 0.25) {
            self.lblSliderLeadingConstraint.constant = xPoint
            self.layoutIfNeeded()
        }
    }
    
    @IBAction func tapBtn(_ sender: UIButton) {
        self.animateSlider(sender.tag)
    }
    
    class func getTabbarView() -> TabbarView {
        return Bundle.main.loadNibNamed("TabbarView", owner: self, options: nil)?.first as! TabbarView
    }
}
