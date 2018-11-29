import Foundation


enum DeviceType: String {
    case LumiWii = "lumiwii"
    case LumiTouch = "lumitouch"
    case LumiPlug = "lumiplug"
    case LumiPlugPro = "lumiplugpro"
    case LumiSwitch = "lumiswitch"
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

