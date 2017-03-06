//
//  ConditionerDevice.swift
//  ConditionController
//
//  Created by Beta 8.0 Technology on 16/10/16.
//  Copyright © 2016 vincenzoOlivito. All rights reserved.
//

import Foundation
import ObjectMapper

// MARK: Initializer and Properties
struct ConditionerDevice: Mappable {
    
    var name: String!
    var model: String!
    var codes: [CodeItem]!
    
    // MARK: JSON
    init?(map: Map) { }
    
    mutating func mapping(map: Map) {
        name <- map["name"]
        model <- map["model"]
        codes <- map["code.codes"]
    }
    
}
