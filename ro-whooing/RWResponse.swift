//
//  RWResponse.swift
//  ro-whooing
//
//  Created by gurren.l on 2015. 5. 7..
//  Copyright (c) 2015년 BoxJeon. All rights reserved.
//

import Foundation

private enum Status: Int {
    
    static let domain = NSBundle.mainBundle().bundleIdentifier!
    
    case OK = 200
    
}

class RWResponse: OVCResponse {
    
    var code: Int?
    var message: String?
    var error: String?
    var rest_of_api: Int?
    
    func getError() -> NSError? {
        if self.code == nil || self.code == Status.OK.rawValue {
            return nil
        } else {
            return NSError(domain: Status.domain, code: self.code ?? -1, userInfo: [NSLocalizedDescriptionKey: error ?? "에러메시지가 없습니다."])
        }
    }
    
}