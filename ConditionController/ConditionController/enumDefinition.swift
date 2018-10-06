//
//  enumDefinition.swift
//  ConditionController
//
//  Created by Vincenzo Olivito on 19/07/2018.
//  Copyright © 2018 vincenzoOlivito. All rights reserved.
//

import Foundation


enum DeviceType: String {
    case DomiWii = "domiwii"
    case DomiTouch = "domitouch"
    case DomiPlug = "domiplug"
    case DomiPlugPro = "domiplugpro"
    case DomiSwitch = "domiswitch"
}

enum ThermostatStatus : Int{
          
        case MANUAL = 1
        case OFF = 2
        case AUTO = 3
        case SCHEDULER = 4
        case BOOST = 5
        case ANTIFREEZE = 6
        case ANTIFORNO = 7
        case SETTINGS = 8
        case ACCESO = 9
        case TIMER = 10
    
    func getStringValue() -> String {
        switch self {
        case .MANUAL:
            return "Manuale"
        case .OFF:
            return "Spento"
        case .AUTO:
            return "Programma"
        case .SCHEDULER:
            return "Programmazione"
        case .BOOST:
            return "Boost"
        case .ANTIFREEZE:
            return "Protezione"
        case .ANTIFORNO:
            return "Protezione"
        case .SETTINGS:
            return "Settings"
        case .ACCESO:
            return "Acceso"
        case .TIMER:
            return "Timer"
        }
    }
}

enum SeasonStatus : Int {
    case INVERNO = 0
    case ESTATE = 1
}

