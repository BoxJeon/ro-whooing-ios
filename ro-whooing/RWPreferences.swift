//
//  RWPreferences.swift
//  ro-whooing
//
//  Created by gurren.l on 2015. 5. 7..
//  Copyright (c) 2015년 BoxJeon. All rights reserved.
//

import Foundation

class RWPreferences {
    
    private static let KEY_TOKEN: String = "KEY_TOKEN"
    private static let KEY_TOKEN_SECRET: String  = "KEY_TOKEN_SECRET"
    private static let KEY_PIN: String = "KEY_PIN"
    private static let KEY_SIGNATURE: String = "KEY_SIGNATURE"
    
    class var appId: Int { return 171 }
    
    class var appSecret: String { return "340ef0c475d2271b67bfca969297e6be9cbb8acc" }
    
    class var token: String? {
        get {
            return NSUserDefaults.standardUserDefaults().objectForKey(KEY_TOKEN) as? String
        }
        set {
            NSUserDefaults.standardUserDefaults().setObject(newValue, forKey: KEY_TOKEN)
        }
    }
    
    class var tokenSecret: String? {
        get {
            return NSUserDefaults.standardUserDefaults().objectForKey(KEY_TOKEN_SECRET) as? String
        }
        set {
            NSUserDefaults.standardUserDefaults().setObject(newValue, forKey: KEY_TOKEN_SECRET)
        }
    }
    
    class var pin: String? {
        get {
            return NSUserDefaults.standardUserDefaults().objectForKey(KEY_PIN) as? String
        }
        set {
            NSUserDefaults.standardUserDefaults().setObject(newValue, forKey: KEY_PIN)
        }
    }
    
    class var signature: String? {
        get {
            return NSUserDefaults.standardUserDefaults().objectForKey(KEY_SIGNATURE) as? String
        }
        set {
            NSUserDefaults.standardUserDefaults().setObject(newValue, forKey: KEY_SIGNATURE)
        }
    }
    
}