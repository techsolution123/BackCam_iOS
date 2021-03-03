//
//  DeviceNameTableCell.swift
//  BagCam
//
//  Created by Pankaj Patel on 19/02/21.
//

import UIKit

/// DeviceNameTableCell
class DeviceNameTableCell: UITableViewCell {
    
    /// @IBOutlet(s)
    @IBOutlet weak var lblTitle: UILabel!
    
    /// Variable Declaration(s)
    var deviceName: String! {
        didSet {
            self.lblTitle.text = deviceName
        }
    }
}
