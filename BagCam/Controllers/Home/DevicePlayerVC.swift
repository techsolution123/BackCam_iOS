//
//  DevicePlayerVC.swift
//  BagCam
//
//  Created by Pankaj Patel on 22/02/21.
//

import UIKit

/// DevicePlayerVC
class DevicePlayerVC: ParentVC {
    
    /// @IBOutlet(s)
    @IBOutlet weak var videoPreview: UIView!
    @IBOutlet weak var imgV: UIImageView!
    @IBOutlet weak var videoControllerView: UIVisualEffectView!
    @IBOutlet weak var btnMic: UIButton!
    @IBOutlet weak var btnSound: UIButton!
    @IBOutlet weak var btnPlayPause: UIButton!
    @IBOutlet weak var btnShield: UIButton!
    @IBOutlet weak var btnCamera: UIButton!
    
    /// View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        AppDelegate.shared.deviceOritentation = .landscape
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        AppDelegate.shared.deviceOritentation = .portrait
    }
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .landscape
    }

    override var shouldAutorotate: Bool {
        return true
    }
}

// MARK: - UI Related Method(s)
extension DevicePlayerVC {
    
    func prepareUI() {
        
    }
}

// MARK: - UIButton Action(s)
extension DevicePlayerVC {
    
    @IBAction func tapBtnMic(_ sender: UIButton) {
        
    }
    
    @IBAction func tapBtnSound(_ sender: UIButton) {
        
    }
    
    @IBAction func tapBtnPlayPause(_ sender: UIButton) {
        
    }
    
    @IBAction func tapBtnShield(_ sender: UIButton) {
        
    }
    
    @IBAction func tapBtnCamera(_ sender: UIButton) {
        
    }
}
