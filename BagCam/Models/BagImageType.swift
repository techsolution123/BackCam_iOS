//
//  BagImageType.swift
//  BagCam
//
//  Created by Kevin Shah on 17/02/21.
//

import Foundation

/// BagImageType
enum BagImageType {
    
    case normal
    case connect
    
    var imageName: String {
        switch self {
        case .normal:
            return "ic_bag"
        case .connect:
            return "ic_bagCamConnect"
        }
    }
}
