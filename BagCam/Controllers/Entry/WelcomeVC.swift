//
//  WelcomeVC.swift
//  BagCam
//
//  Created by Pankaj Patel on 12/02/21.
//

import UIKit

/// WelcomeVC
class WelcomeVC: ParentVC {
    
    /// @IBOutlet(s)
    @IBOutlet weak var btnLogin: UIButton!
    @IBOutlet weak var btnCreateAccount: UIButton!
    
    /// View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        prepareUI()
    }
    
    // Sending data or navigating to another screen
    ///
    /// - Parameters:
    ///   - segue: segue identifier can be multiple
    ///   - sender: can be nil or carried the content data
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "segueLoginVC" {
            
        } else if segue.identifier == "segueSignupVC" {
            
        }
    }
}

// MARK: - UI Related Method(s)
extension WelcomeVC {
    
    func prepareUI() {
        
    }
}

// MARK: - UIButton Action(s)
extension WelcomeVC {
    
    @IBAction func tapBtnLogin(_ sender: UIButton) {
        self.performSegue(withIdentifier: "segueLoginVC", sender: nil)
    }
    
    @IBAction func tapBtnCreateAccount(_ sender: UIButton) {
        self.performSegue(withIdentifier: "segueSignupVC", sender: nil)
    }
}
