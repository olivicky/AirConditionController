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
