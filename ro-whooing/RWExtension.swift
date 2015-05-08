//
//  RWExtension.swift
//  ro-whooing
//
//  Created by gurren.l on 2015. 5. 8..
//  Copyright (c) 2015년 BoxJeon. All rights reserved.
//

import Foundation

extension String {
    
    func sha1() -> String {
        let data = self.dataUsingEncoding(NSUTF8StringEncoding)!
        var digest = [UInt8](count:Int(CC_SHA1_DIGEST_LENGTH), repeatedValue: 0)
        CC_SHA1(data.bytes, CC_LONG(data.length), &digest)
        let hexBytes = map(digest) { String(format: "%02hhx", $0) }
        return "".join(hexBytes)
    }
    
}
