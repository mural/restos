//
//  BundleUtils.swift
//  restos
//
//  Created by Agustin Sgarlata on 5/17/22.
//

import Foundation

struct BundleUtils {
    
    static func getInfoPlistParams() -> NSDictionary? {
        guard let filePath = Bundle.main.path(forResource: "Info", ofType: "plist") else {
            return NSDictionary()
        }
        return NSDictionary(contentsOfFile: filePath)
    }
    
    static func getAPIParams(param: String) -> String {
        guard let value = getInfoPlistParams()?.object(forKey: param) as? String else {
            return ""
        }
        return value
    }

    
    static func getUIModeSwiftUIEnabled() -> Bool {
        let modeKey = "UI_MODE_SWIFT_UI"
        guard let value = getInfoPlistParams()?.object(forKey: modeKey) as? Bool else {
            return false
        }
        return value
    }
    
}
