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
public struct ControlledDevices: Mappable {
    
    var controlledDevicesList : [Device]! = nil
    
    init(device: Device){
        controlledDevicesList = []
        controlledDevicesList.append(device)
    }
    
    // MARK: JSON
    public init?(map: Map) { }
    
    public mutating func mapping(map: Map) {
        controlledDevicesList <- map["response"]
    }
    
}
