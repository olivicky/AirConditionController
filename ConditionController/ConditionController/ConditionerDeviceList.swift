import Foundation
import ObjectMapper

// MARK: Initializer and Properties
struct ConditionerDeviceList: Mappable {
    
    var conditionerDeviceList : [ConditionerDevice]! = nil
    
    // MARK: JSON
    init?(map: Map) { }
    
    mutating func mapping(map: Map) {
        conditionerDeviceList <- map["response"]
    }
    
}
