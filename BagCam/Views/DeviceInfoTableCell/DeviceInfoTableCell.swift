//
//  DeviceOnTableCell.swift
//  BagCam
//
//  Created by Kevin Shah on 19/02/21.
//

import UIKit

/// DeviceOnTableCell
class DeviceInfoTableCell: UITableViewCell {
    
    /// @IBOutlet(s)
    @IBOutlet weak var imgVLeft: UIImageView!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblBattery: UILabel!
    @IBOutlet weak var btnSwitch: UISwitch!
    @IBOutlet weak var imgVRight: UIImageView!
    
    /// Variable Declaration(s)
    var deviceInfoType: DeviceInfoType! {
        didSet {
            imgVLeft.image = UIImage(named: deviceInfoType.imageName)
            lblTitle.text = deviceInfoType.title
            lblBattery.isHidden = !deviceInfoType.isBatteryPercentageVisible
            btnSwitch.isHidden = !deviceInfoType.isDeviceEnableOptionVisible
            imgVRight.image = UIImage(named: deviceInfoType.rightImageName)
            imgVRight.isHidden = deviceInfoType.isDeviceEnableOptionVisible
        }
    }
    
    @IBAction func tapBtnSwitch(_ sender: UISwitch) {
        
    }
}
