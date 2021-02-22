//
//  DeviceInfoType.swift
//  BagCam
//
//  Created by Kevin Shah on 19/02/21.
//

import Foundation

/// DeviceInfoType
enum DeviceInfoType: CaseIterable {
    
    case editName
    case deviceOn
    case battery
    case info
    case grantAccess
    case videoSetting
    case audioSetting
    
    var imageName: String {
        switch self {
        case .editName:
            return "ic_bag"
        case .deviceOn:
            return "ic_shutDown"
        case .battery:
            return "ic_bolt"
        case .info:
            return "ic_info"
        case .grantAccess:
            return "ic_person"
        case .videoSetting:
            return "ic_video"
        case .audioSetting:
            return "ic_soundFull"
        }
    }
    
    var rightImageName: String {
        return (self == .battery) ? "ic_battery" : "ic_rightArrow"
    }
    
    var title: String {
        switch self {
        case .editName:
            return ""
        case .deviceOn:
            return "Device On"
        case .battery:
            return "Battery"
        case .info:
            return "Device Info"
        case .grantAccess:
            return "Grant Access"
        case .videoSetting:
            return "Video Settings"
        case .audioSetting:
            return "Audio Settings"
        }
    }
    
    var isDeviceEnableOptionVisible: Bool {
        return (self == .deviceOn)
    }
    
    var isBatteryPercentageVisible: Bool {
        return (self == .battery)
    }
}
