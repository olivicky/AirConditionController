//
//  ControlledDevices.swift
//  ConditionController
//
//  Created by Vincenzo on 01/04/2017.
//  Copyright © 2017 vincenzoOlivito. All rights reserved.
//

import Foundation
import ObjectMapper

// MARK: Initializer and Properties
struct ControlledDevices: Mappable {
    
    var controlledDevicesList : [Device]! = nil
    
    // MARK: JSON
    init?(map: Map) { }
    
    mutating func mapping(map: Map) {
        controlledDevicesList <- map["response"]
    }
    
}
