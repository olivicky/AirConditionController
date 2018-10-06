//
//  NotificationModel.swift
//  ConditionController
//
//  Created by Vincenzo Olivito on 04/10/2018.
//  Copyright © 2018 vincenzoOlivito. All rights reserved.
//

import Foundation
import ObjectMapper

// MARK: Initializer and Properties
public struct NotificationModel: Mappable {
    
    var uiid: String!
    var password: String!
    var registrationId: String!
    var oldDeviceRegistrationId: String!
    
    public init(){}
    
    // MARK: JSON
    public init?(map: Map) { }
    
    public mutating func mapping(map: Map) {
        uiid <- map["uiid"]
        password <- map["password"]
        registrationId <- map["registrationId"]
        oldDeviceRegistrationId <- map["oldDeviceRegistrationId"]
    }
    
}
