//
//  CodeItem.swift
//  ConditionController
//
//  Created by Beta 8.0 Technology on 02/01/17.
//  Copyright © 2017 vincenzoOlivito. All rights reserved.
//

import Foundation
import ObjectMapper

// MARK: Initializer and Properties
struct CodeItem: Mappable {
    
    var name: String!
    var codes : [Int]!
    
    // MARK: JSON
    init?(map: Map) { }
    
    mutating func mapping(map: Map) {
        name <- map["name"]
        codes <- map["codes"]
    }
    
}
