//
//  UIImageViewExtension.swift
//  BagCam
//
//  Created by Pankaj Patel on 08/03/21.
//

import UIKit
import Kingfisher

extension UIImageView {
    
    func setProfileImageWithDeviceListPlaceholder(_ url: URL?) {
        self.kf.indicatorType = .activity
        self.kf.setImage(with: url, placeholder: UIImage(named: "ic_videoPlaceholder"))
    }
}
