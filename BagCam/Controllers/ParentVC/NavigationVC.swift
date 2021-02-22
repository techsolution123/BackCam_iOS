//
//  NavigationVC.swift
//  BagCam
//
//  Created by Kevin Shah on 12/02/21.
//

import UIKit

/// NavigationVC
class NavigationVC: UINavigationController, UIGestureRecognizerDelegate, UINavigationControllerDelegate {
    
    /// View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        weak var weakSelf: NavigationVC? = self
        interactivePopGestureRecognizer?.delegate = weakSelf!
        delegate = weakSelf!
        isNavigationBarHidden = true
    }
    
    // MARK: - UIGestureRecognizerDelegate
    func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        if viewControllers.count > 1 {
            return true
        } else{
            return false
        }
    }
    
    // MARK: - UINavigationControllerDelegate
    func navigationController(_ navigationController: UINavigationController, didShow viewController: UIViewController, animated: Bool) {
        /// Add every non interactive view controller so controller dont go back automatically.
        if viewController is FullDevicePairingVC ||
            viewController is FullDevicePairedSuccessfullyVC {
            interactivePopGestureRecognizer!.isEnabled = false
        } else {
            interactivePopGestureRecognizer!.isEnabled = true
        }
    }
}
