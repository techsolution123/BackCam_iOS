//
//  BagTableCell.swift
//  BagCam
//
//  Created by Kevin Shah on 17/02/21.
//

import UIKit

/// BagTableCell
class BagTableCell: UITableViewCell {
    
    /// @IBOutlet(s)
    @IBOutlet weak var imgV: UIImageView!
    
    /// Variable Declaration(s)
    var bagImageType: BagImageType! {
        didSet {
            imgV.image = UIImage(named: bagImageType.imageName)
        }
    }
}
