//
//  RWPreferences.swift
//  ro-whooing
//
//  Created by gurren.l on 2015. 5. 7..
//  Copyright (c) 2015년 BoxJeon. All rights reserved.
//

import Foundation

class RWPreferences {
    
    private static let KEY_ACCESS_TOKEN: String  = "KEY_ACCESS_TOKEN"
    
    class var appId: String { return "171" }
    
    class var appSecret: String { return "340ef0c475d2271b67bfca969297e6be9cbb8acc" }
    
    class var accessToken: String? {
        get {
            return NSUserDefaults.standardUserDefaults().objectForKey(KEY_ACCESS_TOKEN) as? String
        }
        set {
            NSUserDefaults.standardUserDefaults().setObject(newValue, forKey: KEY_ACCESS_TOKEN)
        }
    }
    
}