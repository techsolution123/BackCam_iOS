//
//  SuccessMessageTableCell.swift
//  BagCam
//
//  Created by Pankaj Patel on 17/02/21.
//

import UIKit

/// GeneralLabelInfoTableCell
class GeneralLabelInfoTableCell: UITableViewCell {
    
    /// @IBOutlet(s)
    @IBOutlet weak var lblTitle: UILabel!
    
    /// Variable Declaration(s)
    var generalLabelInfoType: GeneralLabelInfoType! {
        didSet {
            lblTitle.attributedText = generalLabelInfoType.attStr
        }
    }
}
