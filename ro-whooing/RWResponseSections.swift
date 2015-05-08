//
//  RWResponseSections.swift
//  ro-whooing
//
//  Created by gurren.l on 2015. 5. 8..
//  Copyright (c) 2015년 BoxJeon. All rights reserved.
//

import Foundation

class RWResponseSections: RWMBase {
    
    var results: Array<RWMSection>?
    
    class func JSONTransformerForKey(key: String!) -> NSValueTransformer? {
        if key == "results" {
            return NSValueTransformer.mtl_JSONArrayTransformerWithModelClass(RWMSection.self)
        } else {
            return nil
        }
    }
    
}