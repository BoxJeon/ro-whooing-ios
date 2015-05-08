//
//  RWRestApiManager.swift
//  ro-whooing
//
//  Created by gurren.l on 2015. 5. 7..
//  Copyright (c) 2015년 BoxJeon. All rights reserved.
//

import Foundation

enum RWApi: Int {
    
    static let baseUrl = "https://whooing.com"
    
    // Authorization
    case RequestToken = 0
    case Authorize
    case AccessToken
    
    case Sections
    case BalanceSheet
    
    case count // set as last.
    
    func getPath() -> String {
        switch self {
        case .RequestToken:
            return "/app_auth/request_token"
        case .Authorize:
            return "/app_auth/authorize"
        case .AccessToken:
            return "/app_auth/access_token"
        case .Sections:
            return "/api/sections.json_array"
        case .BalanceSheet:
            return "/api/bs"
        default:
            return ""
        }
    }
    
    func getPathAndModel() -> (String, AnyClass) {
        switch self {
        case .RequestToken:
            return (self.getPath(), RWResponseAuthorization.self)
        case .Authorize:
            return (self.getPath(), RWResponseAuthorization.self)
        case .AccessToken:
            return (self.getPath(), RWResponseAuthorization.self)
        case .Sections:
            return (self.getPath(), RWResponseSections.self)
        case .BalanceSheet:
            return (self.getPath(), RWResponseBalanceSheet.self)
        default:
            return (self.getPath(), RWMBase.self)
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
        case .BalanceSheet:
            return [
                "section_id": "s199",
                "end_date": "20110604",
            ]
        default:
            return nil
        }
    }
    
}

class RWRestApiManager: OVCHTTPSessionManager {
    
    private static let sharedManager: RWRestApiManager = {
        let manager = RWRestApiManager(baseURL: NSURL(string: RWApi.baseUrl))
        manager.requestSerializer = AFJSONRequestSerializer()
        AFNetworkActivityLogger.sharedLogger().startLogging()
        AFNetworkActivityLogger.sharedLogger().level = .AFLoggerLevelDebug
        return manager
    }()
    
    override class func modelClassesByResourcePath() -> Dictionary<NSObject, AnyObject> {
        var dictionary = Dictionary<NSObject, AnyObject>()
        for (var index = 0; index < RWApi.count.rawValue; ++index) {
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
        let token = RWPreferences.token ?? ""
        var signature = RWPreferences.signature ?? ""
        if count(signature) == 0 {
            if let tokenSecret = RWPreferences.tokenSecret {
                signature = "\(RWPreferences.appSecret)|\(tokenSecret)".sha1()
                RWPreferences.signature = signature
            }
        }
        let nounce = "dc5584feec085bbda9a26e003f702c9b77692625"
        let timeStamp = String(Int(NSDate().timeIntervalSince1970))
        let apiKey = "app_id=\(RWPreferences.appId),token=\(token),signature=\(signature),nounce=\(nounce),timestamp=\(timeStamp)"
        sharedManager.requestSerializer.setValue(apiKey, forHTTPHeaderField: "X-API-KEY")
    }
    
    class func getToken(completion: (error: NSError?, token: String?) -> Void) {
        let api = RWApi.RequestToken
        var path = api.getPath()
        var parameters = api.getParameters()
        sharedManager.GET(path, parameters: parameters, completion: { (response: AnyObject?, error: NSError?) -> Void in
            let envelop = response as? RWResponse
            let authorization = envelop?.result as? RWResponseAuthorization
            completion(error: error ?? envelop?.getError(), token: authorization?.token)
        })
    }
    
    class func getAccessToken(completion: (error: NSError?, token: String?, tokenSecret: String?) -> Void) {
        let api = RWApi.AccessToken
        var path = api.getPath()
        var parameters = api.getParameters()
        sharedManager.GET(path, parameters: parameters, completion: { (response: AnyObject?, error: NSError?) -> Void in
            let envelop = response as? RWResponse
            let authorization = envelop?.result as? RWResponseAuthorization
            completion(error: error ?? envelop?.getError(), token: authorization?.token, tokenSecret: authorization?.token_secret)
        })
    }
    
    class func getSections(completion: (error: NSError?, sections: Array<RWMSection>?) -> Void) {
//        self.setApiKey()
        let api = RWApi.Sections
        var path = api.getPath()
        var parameters = api.getParameters()
        sharedManager.GET(path, parameters: parameters, completion: { (response: AnyObject?, error: NSError?) -> Void in
            let envelop = response as? RWResponse
            let result = envelop?.result as? RWResponseSections
            completion(error: error ?? envelop?.getError(), sections: result?.results)
        })
    }
    
//    class func getBalanceSheet(completion: (error: NSError?) -> Void) {
//        self.setApiKey()
//        let api = RWApi.BalanceSheet
//        var path = api.getPath()
//        var parameters = api.getParameters()
//        sharedManager.GET(path, parameters: parameters, completion: { (response: AnyObject?, error: NSError?) -> Void in
//            let envelop = response as? RWResponse
//            let result = envelop?.result as? RWResponseBalanceSheet
//            completion(error: error ?? envelop?.getError())
//        })
//    }
    
}