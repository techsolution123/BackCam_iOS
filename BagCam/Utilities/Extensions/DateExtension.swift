//
//  DateExtension.swift
//  BagCam
//
//  Created by Pankaj Patel on 26/02/21.
//

import UIKit

extension Date {
    
    static let formatter1: DateFormatter = {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "en")
        formatter.timeZone = TimeZone(secondsFromGMT: 0)
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        return formatter
    }()
}
