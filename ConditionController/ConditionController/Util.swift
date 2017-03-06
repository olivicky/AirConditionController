//
//  Util.swift
//  ConditionController
//
//  Created by Beta 8.0 Technology on 06/10/16.
//  Copyright © 2016 vincenzoOlivito. All rights reserved.
//

import Foundation
import SystemConfiguration.CaptiveNetwork

public class Util {
    class func getSSID() -> String? {
        
        let interfaces = CNCopySupportedInterfaces()
        if interfaces == nil {
            return nil
        }
        
        let interfacesArray = interfaces as! [String]
        if interfacesArray.count <= 0 {
            return nil
        }
        
        let interfaceName = interfacesArray[0] as String
        let unsafeInterfaceData =     CNCopyCurrentNetworkInfo(interfaceName as CFString)
        if unsafeInterfaceData == nil {
            return nil
        }
        
        let interfaceData = unsafeInterfaceData as! Dictionary <String,AnyObject>
        
        return interfaceData["SSID"] as? String
    }
}
