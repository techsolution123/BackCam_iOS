//
//  DictionaryExtension.swift
//  BagCam
//
//  Created by Pankaj Patel on 16/02/21.
//

import UIKit

// MARK: - Conversion Related Method(s)
extension Dictionary where Key == String, Value == Any {
    
    func string(_ key: String) -> String {
        if let value = self[key] as? NSNumber {
            return value.stringValue
        } else if let str = self[key] as? String {
            return str
        }
        return ""
    }
    
    func optionalDate(_ anything: Any?) -> Date? {
        if let any = anything {
            if let str = any as? String, !str.isEmpty {
                if str.contains(find: "-") || str.contains(find: ":") {
                    return Date.formatter1.date(from: str)
                } else {
                    return Date(timeIntervalSince1970: double(str))
                }
            } else if let str = any as? NSNumber {
                return Date(timeIntervalSince1970: str.doubleValue)
            }
        }
        return nil
    }
    
    func integer(_ key: String) -> Int {
        if let value = self[key] as? NSNumber {
            return value.intValue
        } else if let str = self[key] as? NSString {
            return str.integerValue
        }
        return 0
    }
    
    func integer32(_ key: String) -> Int32 {
        if let value = self[key] as? NSNumber {
            return value.int32Value
        } else if let str = self[key] as? NSString {
            return str.intValue
        }
        return 0
    }
    
    func double(_ key: String) -> Double {
        if let value = self[key] as? NSNumber {
            return value.doubleValue
        } else if let str = self[key] as? NSString {
            return str.doubleValue
        }
        return 0.0
    }
    
    func boolean(_ key: String) -> Bool {
        if let value = self[key] as? NSNumber {
            return value.boolValue
        } else if let str = self[key] as? NSString {
            return str.boolValue
        }
        return false
    }
    
    func merge(_ dict: [String: Any]) -> [String: Any] {
        return self.merging(dict, uniquingKeysWith: {(_, new) in new})
    }
}

extension Collection {
    
    func toJSONString(options: JSONSerialization.WritingOptions = .prettyPrinted) -> String {
        if let dat = try? JSONSerialization.data(withJSONObject: self, options: options),
            let str = String(data: dat, encoding: String.Encoding.utf8) {
            return str
        }
        return "[]"
    }
}
