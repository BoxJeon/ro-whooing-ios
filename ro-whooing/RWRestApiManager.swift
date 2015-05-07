//
//  RWRestApiManager.swift
//  ro-whooing
//
//  Created by gurren.l on 2015. 5. 7..
//  Copyright (c) 2015년 BoxJeon. All rights reserved.
//

import Foundation

private enum Api: Int {
    
    static let baseUrl = NSURL(string: "https://whooing.com")
    
    // Authorization
    case RequestToken = 0
    case Authorize
    case AccessToken
    
    static let count: Int = 3
    
    func getPathAndModel() -> (String, AnyClass) {
        switch self {
        case .RequestToken:
            return ("/app_auth/request_token", RWRestApiManager.self)
        case .Authorize:
            return ("/app_auth/authorize", RWRestApiManager.self)
        case .AccessToken:
            return ("/app_auth/access_token", RWRestApiManager.self)
        }
    }
    
}

class RWRestApiManager: OVCHTTPSessionManager {
    
    private static let sharedManager: RWRestApiManager = {
        let manager = RWRestApiManager(baseURL: Api.baseUrl)
        AFNetworkActivityLogger.sharedLogger().startLogging()
        AFNetworkActivityLogger.sharedLogger().level = .AFLoggerLevelDebug
        return manager
    }()
    
    override class func modelClassesByResourcePath() -> Dictionary<NSObject, AnyObject> {
        var dictionary = Dictionary<NSObject, AnyObject>()
        for (var index = 0; index < Api.count; ++index) {
            let (path, model): (String, AnyClass) = Api(rawValue: index)!.getPathAndModel()
            dictionary[path] = model
        }
        return dictionary
    }
    
}