//
//  ViewController.swift
//  BagCam
//
//  Created by Kevin Shah on 12/02/21.
//

import UIKit

/// LoadingVC
class LoadingVC: ParentVC {
    
    /// @IBOutlet(s)
    @IBOutlet weak var lblVersion: UILabel!
    
    /// View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        prepareUI()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        navigateUserToWelcomeScreenAfter(1.0)
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    // Sending data or navigating to another screen
    ///
    /// - Parameters:
    ///   - segue: segue identifier can be multiple
    ///   - sender: can be nil or carried the content data
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "segueNavigationVCWelcomeVC" {
            
        }
    }
}

// MARK: - UI Related Method(s)
extension LoadingVC {
    
    func prepareUI() {
        prepareVersionInfo()
    }
    
    func prepareVersionInfo() {
        var infoStr: String = ""
        if let version = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String {
            infoStr += "V: \(version)"
        }
        self.lblVersion.text = infoStr
    }
    
    func navigateUserToWelcomeScreenAfter(_ delay: Double) {
        DispatchQueue.main.asyncAfter(deadline: .now() + delay) {
            self.performSegue(withIdentifier: "segueNavigationVCWelcomeVC", sender: nil)
        }
    }
}

