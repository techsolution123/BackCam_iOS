//
//  TabbarVC.swift
//  BagCam
//
//  Created by Kevin Shah on 18/02/21.
//

import UIKit

/// TabbarVC
class TabbarVC: UITabBarController {
    
    /// Variable Declaration(s)
    var tabbarView: TabbarView!
    
    /// View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        prepareUI()
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        let height: CGFloat = 50 + self.view.safeAreaInsets.bottom
        let yPosition: CGFloat = self.view.frame.height - height
        self.tabbarView?.frame = CGRect(x: 0, y: yPosition, width: self.view.frame.size.width, height: height)
    }
}

// MARK: - UI Related Method(s)
extension TabbarVC {
    
    func prepareUI() {
        self.tabBar.isHidden = true
        self.view.layoutIfNeeded()
        self.tabbarView = TabbarView.getTabbarView()
        let height: CGFloat = 50 + self.view.safeAreaInsets.bottom
        let yPosition: CGFloat = self.view.frame.height - height
        self.tabbarView.frame = CGRect(x: 0, y: yPosition, width: self.view.frame.size.width, height: height)
        self.view.addSubview(self.tabbarView)
        self.tabbarView.selectionCompletion = { [weak self] (index) in
            guard let self = self else {
                return
            }
            print(index)
        }
    }
}
