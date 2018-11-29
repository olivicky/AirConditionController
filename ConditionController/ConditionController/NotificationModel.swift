import Foundation
import ObjectMapper

// MARK: Initializer and Properties
public struct NotificationModel: Mappable {
    
    var uiid: String!
    var password: String!
    var registrationId: String!
    var oldDeviceRegistrationId: String!
    
    public init(){}
    
    // MARK: JSON
    public init?(map: Map) { }
    
    public mutating func mapping(map: Map) {
        uiid <- map["uiid"]
        password <- map["password"]
        registrationId <- map["registrationId"]
        oldDeviceRegistrationId <- map["oldDeviceRegistrationId"]
    }
    
}
