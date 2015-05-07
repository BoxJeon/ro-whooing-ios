//
//  RWRestApiManager.swift
//  ro-whooing
//
//  Created by gurren.l on 2015. 5. 7..
//  Copyright (c) 2015년 BoxJeon. All rights reserved.
//

import Foundation

enum RWApi: Int {
    
    static let baseUrl = NSURL(string: "https://whooing.com")
    
    // Authorization
    case RequestToken = 0
    case Authorize
    case AccessToken
    
    static let count: Int = 3
    
    func getPathAndModel() -> (String, AnyClass) {
        switch self {
        case .RequestToken:
            return ("/app_auth/request_token", RWResponseAuthorization.self)
        case .Authorize:
            return ("/app_auth/authorize", RWResponseAuthorization.self)
        case .AccessToken:
            return ("/app_auth/access_token", RWResponseAuthorization.self)
        }
    }
    
    func getParameters() -> Dictionary<String, AnyObject>? {
        switch self {
        case .RequestToken:
            return [
                "app_id": RWPreferences.appId,
                "app_secret": RWPreferences.appSecret,
            ]
        case .AccessToken:
            return [
                "app_id": RWPreferences.appId,
                "app_secret": RWPreferences.appSecret,
                "token": RWPreferences.token ?? "",
                "pin": RWPreferences.pin ?? "",
            ]
        default:
            return nil
        }
    }
    
}

class RWRestApiManager: OVCHTTPSessionManager {
    
    private static let sharedManager: RWRestApiManager = {
        let manager = RWRestApiManager(baseURL: RWApi.baseUrl)
        manager.requestSerializer = AFJSONRequestSerializer()
        AFNetworkActivityLogger.sharedLogger().startLogging()
        AFNetworkActivityLogger.sharedLogger().level = .AFLoggerLevelDebug
        return manager
    }()
    
    override class func modelClassesByResourcePath() -> Dictionary<NSObject, AnyObject> {
        var dictionary = Dictionary<NSObject, AnyObject>()
        for (var index = 0; index < RWApi.count; ++index) {
            let (path, model): (String, AnyClass) = RWApi(rawValue: index)!.getPathAndModel()
            dictionary[path] = model
        }
        return dictionary
    }
    
    override class func responseClass() -> AnyClass {
        return RWResponse.self
    }
    
    class func setApiKey() {
        // TODO: api key generation, set as header.
        alksdjf;ajd
    }
    
    class func getToken(completion: (error: NSError?, token: String?) -> Void) {
        let api = RWApi.RequestToken
        var (path, _) = api.getPathAndModel()
        var parameters = api.getParameters()
        sharedManager.GET(path, parameters: parameters, completion: { (response: AnyObject?, error: NSError?) -> Void in
            let envelop = response as? RWResponse
            let authorization = envelop?.result as? RWResponseAuthorization
            completion(error: error ?? envelop?.getError(), token: authorization?.token)
        })
    }
    
    class func getAccessToken(completion: (error: NSError?, token: String?, tokenSecret: String?) -> Void) {
        let api = RWApi.AccessToken
        var (path, _) = api.getPathAndModel()
        var parameters = api.getParameters()
        sharedManager.GET(path, parameters: parameters, completion: { (response: AnyObject?, error: NSError?) -> Void in
            let envelop = response as? RWResponse
            let authorization = envelop?.result as? RWResponseAuthorization
            completion(error: error ?? envelop?.getError(), token: authorization?.token, tokenSecret: authorization?.token_secret)
        })
    }
    
}