//
//  AppSetup.swift
//  ConditionController
//
//  Created by Beta 8.0 Technology on 15/10/16.
//  Copyright © 2016 vincenzoOlivito. All rights reserved.
//

import Foundation

class AppSetup {
    
    let readyDevicesCounter : Int!
    
    
    class var sharedState : AppSetup {
        struct Static {
            static let instance = AppSetup()
        }
        return Static.instance
    }
    
    init() {
        let defaults = UserDefaults.standard
        
        readyDevicesCounter = defaults.integer(forKey: "READYDEVICECOUNTER")
        
    }
    
    
    
    
    
}
