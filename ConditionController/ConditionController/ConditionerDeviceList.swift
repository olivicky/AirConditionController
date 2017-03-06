//
//  ConditionerDeviceList.swift
//  ConditionController
//
//  Created by Beta 8.0 Technology on 16/10/16.
//  Copyright © 2016 vincenzoOlivito. All rights reserved.
//

import Foundation
import ObjectMapper

// MARK: Initializer and Properties
struct ConditionerDeviceList: Mappable {
    
    var conditionerDeviceList : [ConditionerDevice]! = nil
    
    // MARK: JSON
    init?(map: Map) { }
    
    mutating func mapping(map: Map) {
        conditionerDeviceList <- map["response"]
    }
    
}
