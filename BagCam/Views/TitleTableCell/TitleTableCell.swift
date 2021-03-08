//
//  TitleTableCell.swift
//  BagCam
//
//  Created by Pankaj Patel on 12/02/21.
//

import UIKit

/// TitleTableCell
class TitleTableCell: UITableViewCell {
    
    /// @IBOutlet(s)
    @IBOutlet weak var lblTitle: UILabel!
    
    /// Variable Declaration(s)
    var userInputFieldType: UserInputFieldType! {
        didSet {
            lblTitle.attributedText = userInputFieldType.titleAttr
        }
    }
}
