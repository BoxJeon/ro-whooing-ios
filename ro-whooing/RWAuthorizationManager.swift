//
//  RWAuthorizationManager.swift
//  ro-whooing
//
//  Created by gurren.l on 2015. 5. 7..
//  Copyright (c) 2015년 BoxJeon. All rights reserved.
//

import Foundation

class RWAuthorizationManager {
    
    static let NOTIFICATION_LOGIN_SUCCESS = "NOTIFICATION_LOGIN_SUCCESS"
    static let NOTIFICATION_LOGIN_FAIL = "NOTIFICATION_LOGIN_FAIL"
    static let NOTIFICATION_LOGOUT_SUCCESS = "NOTIFICATION_LOGOUT_SUCCESS"
    
    class func isLoggedIn() -> Bool {
        return count(RWPreferences.tokenSecret ?? "") > 0
    }
    
    class func login() {
        RWRestApiManager.getAccessToken({ (error, token, tokenSecret) -> Void in
            if error == nil {
                RWPreferences.token = token
                RWPreferences.tokenSecret = tokenSecret
                NSNotificationCenter.defaultCenter().postNotificationName(RWAuthorizationManager.NOTIFICATION_LOGIN_SUCCESS, object: nil)
            } else {
                // TODO: 에러처리
                NSNotificationCenter.defaultCenter().postNotificationName(RWAuthorizationManager.NOTIFICATION_LOGIN_FAIL, object: nil)
            }
        })
    }

    class func logout() {
        RWPreferences.token = nil
        RWPreferences.pin = nil
        RWPreferences.tokenSecret = nil
        NSNotificationCenter.defaultCenter().postNotificationName(NOTIFICATION_LOGOUT_SUCCESS, object: nil)
    }
}