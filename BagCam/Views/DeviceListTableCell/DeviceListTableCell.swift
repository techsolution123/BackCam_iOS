//
//  DeviceListTableCell.swift
//  BagCam
//
//  Created by Kevin Shah on 19/02/21.
//

import UIKit

/// DeviceListTableCell
class DeviceListTableCell: UITableViewCell {
    
    /// @IBOutlet(s)
    @IBOutlet weak var lblVideoTime: UILabel!
    @IBOutlet weak var btnFullVideoScreen: UIButton!
    @IBOutlet weak var imgVVideoThumbnail: UIImageView!
    @IBOutlet weak var btnGoLive: UIButton!
    
    /// Video Control(s)
    @IBOutlet weak var videoControllerView: UIVisualEffectView!
    @IBOutlet weak var btnMic: UIButton!
    @IBOutlet weak var btnSound: UIButton!
    @IBOutlet weak var btnPlayPause: UIButton!
    @IBOutlet weak var btnShield: UIButton!
    @IBOutlet weak var btnCamera: UIButton!
    
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var btnNetwork: UIButton!
    @IBOutlet weak var btnCloud: UIButton!
    @IBOutlet weak var btnBattery: UIButton!
    @IBOutlet weak var btnNumberOfEvent: UIButton!
    @IBOutlet weak var btnSetting: UIButton!
    
    /// Variable Declaration(s)
    weak var parentHomeVC: HomeVC!
    
    var isVideoControllerHidden: Bool = true {
        didSet {
            self.videoControllerView.isHidden = isVideoControllerHidden
            self.btnFullVideoScreen.isHidden = isVideoControllerHidden
            self.btnGoLive.isHidden = !isVideoControllerHidden
        }
    }
}

// MARK: - UIButton Action(s)
extension DeviceListTableCell {
    
    @IBAction func tapBtnFullVideoScreen(_ sender: UIButton) {
        self.parentHomeVC.performSegue(withIdentifier: "segueDevicePlayerVC", sender: nil)
    }
    
    @IBAction func tapBtnGoLive(_ sender: UIButton) {
        isVideoControllerHidden = false
    }
    
    @IBAction func tapBtnMic(_ sender: UIButton) {
        
    }
    
    @IBAction func tapBtnSound(_ sender: UIButton) {
        
    }
    
    @IBAction func tapBtnPlayPause(_ sender: UIButton) {
        isVideoControllerHidden = true
    }
    
    @IBAction func tapBtnShield(_ sender: UIButton) {
        
    }
    
    @IBAction func tapBtnCamera(_ sender: UIButton) {
        
    }
    
    @IBAction func tapBtnNetwork(_ sender: UIButton) {
        
    }
    
    @IBAction func tapBtnCloud(_ sender: UIButton) {
        
    }
    
    @IBAction func tapBtnBattery(_ sender: UIButton) {
        
    }
    
    @IBAction func tapBtnNumberOfEvent(_ sender: UIButton) {
        
    }
    
    @IBAction func tapBtnSetting(_ sender: UIButton) {
        self.parentHomeVC.performSegue(withIdentifier: "segueDeviceSettingVC", sender: nil)
    }
}
