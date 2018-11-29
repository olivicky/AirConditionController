import Foundation
import ObjectMapper

// MARK: Initializer and Properties
public struct ControlledNotificationDevices: Mappable {
    
    var controlledDevicesList : [NotificationModel]! = nil
    
    init(device: NotificationModel){
        controlledDevicesList = []
        controlledDevicesList.append(device)
    }
    
    init(){
        controlledDevicesList = []
    }
    
    // MARK: JSON
    public init?(map: Map) { }
    
    public mutating func mapping(map: Map) {
        controlledDevicesList <- map["response"]
    }
    
}
