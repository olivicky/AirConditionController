import Foundation
import RealmSwift
import ObjectMapper
import ObjectMapperAdditions
import ObjectMapper_Realm

class Device: Object, Mappable{
    
    dynamic var notificationToken : String?
    dynamic var alias: String!
    dynamic var password: String!
    dynamic var temperature: String!
    dynamic var humidity : String!
    dynamic var uid: String!
    //stored value
    dynamic var _planning: String?
    var planning : [[Int]] {
        get{
            let data = _planning?.data(using: .utf8)
            
            if let json = try? JSONSerialization.jsonObject(with: data!, options: .allowFragments) as? [[Int]]{
                return json!
            }
            
            return []
        }
    }
    //stored value
    dynamic var _type: String!
    //exposed value
    var type : DeviceType!{
        get {
            return DeviceType(rawValue: _type)
        }
        set{
            _type = newValue.rawValue
        }
    }
    //stored value
    dynamic var _status : Int = -1
    //exposed value
    var status : ThermostatStatus!{
        get {
            return ThermostatStatus(rawValue: _status)
        }
        set{
            _status = newValue.rawValue
        }
    }
    dynamic var power_reactive : String?
    dynamic var power_active :String?
    dynamic var max_power : Int = -1
    dynamic var set_point :Int = 0
    dynamic var set_point_benessere :Int = 0
    dynamic var set_point_eco :Int = 0
    dynamic var running_mode: String?
    
    var is_running: Bool?
    // stored value
    var mode = -1
    //exposed value
    var season : SeasonStatus!{
        get {
            return SeasonStatus(rawValue: mode)
        }
        set{
            mode = newValue.rawValue
        }
    }
    
    dynamic var _consumption : String?
    var consumption : [Int] {
        get{
            let data = _consumption?.data(using: .utf8)
            
            if(data != nil){
                if let json = try? JSONSerialization.jsonObject(with: data!, options: .allowFragments) as? [Int]{
                    return json!
                }
            }
            
            return []
        }
    }
    dynamic var _daily_temperature :String?
    var daily_temperature : [Int] {
        get{
            let data = _daily_temperature?.data(using: .utf8)
            
            if(data != nil){
                if let json = try? JSONSerialization.jsonObject(with: data!, options: .allowFragments) as? [Int]{
                    return json!
                }
            }
            
            return []
        }
    }
    dynamic var _daily_timeron :String?
    var daily_timeron : [Int] {
        get{
            let data = _daily_timeron?.data(using: .utf8)
            
            if(data != nil){
                if let json = try? JSONSerialization.jsonObject(with: data!, options: .allowFragments) as? [Int]{
                    return json!
                }
            }
            
            return []
        }
    }
    dynamic var min_temperature :Int = 0
    dynamic var max_temperature :Int = 0
    var day = 0
    var hh = 0
    var mm = 0
    dynamic var timerOn :Int = 0
    
    
    //settings
    dynamic var enableBotNotification : Bool = false
    dynamic var enableMobileNotification : Bool = false
    var faulty = -1
    
    
    
    override static func primaryKey()->String?{ return "uid"}
    
    override static func ignoredProperties() -> [String] { return ["type", "status", "planning", "season", "daily_temperature", "consumption"] }
    
    required convenience init?(map: Map) {
        self.init()
    }
    
    func mapping(map: Map) {
        alias <- map["alias"]
        temperature <- map["temperature"]
        humidity <- map["humidity"]
        uid <- map["uiid"]
        _type <- (map["uiid"], transformerDeviceType)
        _planning <- map["planning"]
        power_reactive <- map["power_reactive"]
        power_active <- map["power_active"]
        max_power <- map["maxPower"]
        set_point <- map["setPoint"]
        set_point_benessere <- map["setPointBenessere"]
        set_point_eco <- map["setPointEco"]
        running_mode <- map["running_mode"]
        _status <- map["status"]
        is_running <- map["isRunning"]
        mode <- map["mode"]
        _consumption <- map["consumption"]
        _daily_temperature <- map["daily_temperature"]
        _daily_timeron <- map["daily_timeron"]
        min_temperature <- map["minTemperature"]
        max_temperature <- map["maxTemperature"]
        day <- map["day"]
        hh <- map["hh"]
        mm <- map["mm"]
        timerOn <- map["timerOn"]
        enableBotNotification <- map["enableBotNotification"]
        enableMobileNotification <- map["enableMobileNotification"]
        faulty <- map["faulty"]
    }
        
        
        
    

    let transformerDeviceType = TransformOf<String, String>(fromJSON: { (value: String?) -> String? in
        if(value!.hasPrefix("2")){
            return "lumitouch"
        }
        else if(value!.hasPrefix("3")){
            return "lumiplug"
        }
        else if(value!.hasPrefix("4")){
            return "lumiplugpro"
        }
        else if(value!.hasPrefix("5")){
            return "dlumiswitch"
        }
        else{
            return "lumiwii"
        }
    }, toJSON: { (value: String?) -> String? in
        // transform value from Int? to String?
        if let value = value {
            return value
        }
        return nil
    })
}
