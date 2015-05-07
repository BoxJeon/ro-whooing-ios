//
//  RWMBase.swift
//  ro-whooing
//
//  Created by gurren.l on 2015. 5. 7..
//  Copyright (c) 2015년 BoxJeon. All rights reserved.
//

import Foundation

class RWMBase: MTLModel, MTLJSONSerializing {
    
    class func JSONKeyPathsByPropertyKey() -> [NSObject : AnyObject]? {
        return nil // <variable name>: <json name>
    }

}