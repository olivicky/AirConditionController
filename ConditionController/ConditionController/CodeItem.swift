import Foundation
import ObjectMapper

// MARK: Initializer and Properties
struct CodeItem: Mappable {
    
    var name: String!
    var codes : [Int]!
    
    // MARK: JSON
    init?(map: Map) { }
    
    mutating func mapping(map: Map) {
        name <- map["name"]
        codes <- map["codes"]
    }
    
}
