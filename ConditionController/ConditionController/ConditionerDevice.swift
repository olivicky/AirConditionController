import Foundation
import ObjectMapper

// MARK: Initializer and Properties
struct ConditionerDevice: Mappable {
    
    var name: String!
    var model: String!
    var codes: [CodeItem]!
    
    // MARK: JSON
    init?(map: Map) { }
    
    mutating func mapping(map: Map) {
        name <- map["name"]
        model <- map["model"]
        codes <- map["code.codes"]
    }
    
}
