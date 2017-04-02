//
//  Conditioner.swift
//  ConditionController
//
//  Created by Beta 8.0 Technology on 05/10/16.
//  Copyright © 2016 vincenzoOlivito. All rights reserved.
//

import Foundation
import RealmSwift
import ObjectMapper

class Device: Object, Mappable{
    
    dynamic var alias: String!
    dynamic var password: String!
    dynamic var temperature: String!
    dynamic var humidity : String!
    dynamic var uid: String!
    
    
    override static func primaryKey()->String?{ return "uid"}
    
    required convenience init?(map: Map) {
        self.init()
    }
    
    func mapping(map: Map) {
        alias <- map["alias"]
        temperature <- map["temperature"]
        humidity <- map["humidity"]
        uid <- map["uiid"]
    }
    
}
