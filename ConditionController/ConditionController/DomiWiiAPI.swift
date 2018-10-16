//
//  DomiWiiAPI.swift
//  ConditionController
//
//  Created by Beta 8.0 Technology on 12/10/16.
//  Copyright © 2016 vincenzoOlivito. All rights reserved.
//

import Foundation
import Moya
import Alamofire

// MARK: - Provider setup

private func JSONResponseDataFormatter(_ data: Data) -> Data {
    do {
        let dataAsJSON = try JSONSerialization.jsonObject(with: data)
        let prettyData =  try JSONSerialization.data(withJSONObject: dataAsJSON, options: .prettyPrinted)
        return prettyData
    } catch {
        return data //fallback to original data if it cant be serialized
    }
}

let manager = Manager(
    configuration: URLSessionConfiguration.default
)

class DefaultAlamofireManager: Alamofire.SessionManager {
    static let sharedManager: DefaultAlamofireManager = {
        let configuration = URLSessionConfiguration.default
        //configuration.httpAdditionalHeaders = Alamofire.SessionManager.defaultHTTPHeaders
        configuration.timeoutIntervalForRequest = 20 // as seconds, you can set your request timeout
        configuration.timeoutIntervalForResource = 20 // as seconds, you can set your resource timeout
        //configuration.requestCachePolicy = .useProtocolCachePolicy
        return DefaultAlamofireManager(configuration: configuration)
    }()
}



let endpointClosure = { (target: DomiWii) -> Endpoint in
    let url = target.baseURL.appendingPathComponent(target.path).absoluteString
    var encoding: Moya.ParameterEncoding = JSONEncoding()
    
    switch target.method {
    case Moya.Method.get:
        encoding = URLEncoding()
    default:
        encoding = JSONEncoding()
        //encoding = JsonArrayEncoding()
    }
    
    
    let endpoint: Endpoint = Endpoint(url: url, sampleResponseClosure: {.networkResponse(200, target.sampleData)}, method: target.method, task: target.task, httpHeaderFields: target.headers)
    
    return endpoint
}

//let DomiWiiProvider = MoyaProvider<DomiWii>(endpointClosure: MoyaProvider,
//                                            requestClosure: MoyaProvider.defaultRequestMapping,
//                                            stubClosure: MoyaProvider.neverStub,
//                                            manager: manager,
//                                            plugins: [NetworkLoggerPlugin(verbose: true, responseDataFormatter: nil)])

let DomiWiiProvider = MoyaProvider<DomiWii>(manager: DefaultAlamofireManager.sharedManager, plugins:[NetworkLoggerPlugin(verbose: true, responseDataFormatter: nil)])

// MARK: - Provider support

private extension String {
    var urlEscapedString: String {
        return self.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)!
    }
}

public enum DomiWii {
    case devicesMetadata(aliases : [String])
    case conditionerList()
    case sendConditionerAction(alias: String, mode: String, speed: String?, temperature: String?, confort: String?)
    case updateDeviceProp(password : String, newPassword : String, alias : String, newAlias : String)
    case checkDevice(alias: String, password: String)
    case resetDevice(alias: String, password: String)
    case subscribeDevicesNotification(devices : ControlledNotificationDevices)
    case unsubscribeDevicesNotification(devices : NotificationModel)
    case sendDeviceAction(alias: String, password: String, uuid: String, command: Int, day: Int?, hour: Int?, minutes: Int?, cap: Int?, setPointBenessere: Int?, setPointEco: Int?, mode: Int?, minTemperature: Int?, maxTemperatura: Int?, notificationPeriod: Int?, enableMobileNotification: Bool?, enableBotNotification: Bool?, temperature: Int?, timeOn: Int?, planning: [[Int]]? )
    
    
}

extension DomiWii: TargetType {
    
    public var headers: [String : String]? {
        return ["Content-Type": "application/json"]
    }
    
    public var baseURL: URL { return URL(string: "https://domiwiiapp.herokuapp.com")! }
    public var path: String {
        switch self {
        case .devicesMetadata:
            return "/devicesMetadata"
        case .conditionerList:
            return "/conditionerList"
        case .sendConditionerAction:
            return "/addBotAction"
        case .updateDeviceProp:
            return "/updateDevice"
        case .checkDevice:
            return "/checkDeviceByUid"
        case .resetDevice:
            return "/resetDevice"
        case .sendDeviceAction:
            return "/addAction"
        case .subscribeDevicesNotification:
            return "/subscribeDevicesNotification"
        case .unsubscribeDevicesNotification:
            return "/unSubscribeDeviceNotification"
        }
    }
    
    public var method: Moya.Method {
        return Moya.Method.post
    }
    
    
//    public var parameters: Task {
//        switch self {
//        case .devicesMetadata(let aliases):
//            return  ["jsonArray" : aliases]
//        case .sendConditionerAction(let alias, let  mode, let speed, let temperature, let confort):
//            return [
//                "alias" : alias,
//                "mode" : mode,
//                "speed": (speed != nil ? speed : "-1" ),
//                "temperature": (temperature != nil ? temperature : "-1"),
//                "confort": (confort != nil ? confort : "-1")
//            ]
//        case .updateDeviceProp(let password, let newPassword, let alias, let newAlias):
//            return [
//                "password" : password,
//                "newPassword" : newPassword,
//                "alias" : alias,
//                "newAlias" : newAlias
//            ]
//        case .checkDevice(let alias, let password):
//            return [
//                "alias": "",
//                "password": password,
//                "uid": alias
//            ]
//        case .resetDevice(let alias, let password):
//            return [
//                "alias":alias,
//                "newAlias": "",
//                "password": password,
//                "newPassword": ""
//            ]
//
//        default:
//            return nil
//        }
//    }
    

    public var parameterEncoding: Moya.ParameterEncoding  {
     
        switch self {
        case .devicesMetadata:
            return JsonArrayEncoding.default
            //return ParameterEncoding.custom(JsonArrayEncodingClosure)
        default:
            return JSONEncoding.default
        }
    }

    
    public var task: Task {
        switch self {
        case .devicesMetadata(let aliases):
            return .requestParameters(parameters: ["jsonArray" : aliases], encoding: JsonArrayEncoding.default)
        case .sendConditionerAction(let alias, let  mode, let speed, let temperature, let confort):
            return .requestParameters(parameters: [
                "alias" : alias,
                "mode" : mode,
                "speed": (speed != nil ? speed : "-1" ),
                "temperature": (temperature != nil ? temperature : "-1"),
                "confort": (confort != nil ? confort : "-1")
                ], encoding: JSONEncoding.default)
        case .updateDeviceProp(let password, let newPassword, let alias, let newAlias):
            return .requestParameters(parameters: [
                "password" : password,
                "newPassword" : newPassword,
                "alias" : alias,
                "newAlias" : newAlias
                ], encoding: JSONEncoding.default)
        case .checkDevice(let alias, let password):
            return .requestParameters(parameters: [
                "alias": "",
                "password": password,
                "uid": alias
                ], encoding: JSONEncoding.default)
        case .resetDevice(let alias, let password):
            return .requestParameters(parameters: [
                "alias":alias,
                "newAlias": "",
                "password": password,
                "newPassword": ""
                ], encoding: JSONEncoding.default)
        case .sendDeviceAction(let alias,let password, let uuid, let command, let day, let hour, let minutes, let cap, let setPointBenessere, let setPointEco, let mode, let minTemperature, let maxTemperature, let notificationPeriod, let enableMobileNotification, let enableBotNotification, let temperature, let timeOn, let planning):
            var params: [String:Any] = [:]
            params["alias"] = alias
            params["password"] = password
            params["uiid"] = uuid
            params["command"] = command
            params["day"] = day
            params["hour"] = hour
            params["minutes"] = minutes
            params["cap"] = cap
            params["setPointBenessere"] = setPointBenessere
            params["setPointEco"] = setPointEco
            params["mode"] = mode
            params["minTemperature"] = minTemperature
            params["maxTemperature"] = maxTemperature
            params["notificationPeriod"] = notificationPeriod
            params["enableMobileNotification"] = enableMobileNotification
            params["enableBotNotification"] = enableBotNotification
            params["temperature"] = temperature
            params["timeOn"] = timeOn
            params["planning"] = planning
            return .requestParameters(parameters:params, encoding: JSONEncoding.default)
        case .subscribeDevicesNotification(let devices):
            return .requestParameters(parameters: ["jsonArray" : devices.controlledDevicesList.toJSONString(prettyPrint: true)], encoding: JsonArrayObjectEncoding.default)

        case .unsubscribeDevicesNotification(let devices):
            return .requestParameters(parameters: ["jsonArray" : devices.toJSONString(prettyPrint: true)], encoding: JsonArrayObjectEncoding.default)

        default:
            return .requestPlain
            
        }
        
    }
    
    public var sampleData: Data {
        switch self {
        case .devicesMetadata:
            return "Half measures are as bad as nothing at all.".data(using: String.Encoding.utf8)!
        case .conditionerList(let name):
            return "{\"login\": \"\(name)\", \"id\": 100}".data(using: String.Encoding.utf8)!
        case .sendConditionerAction(_):
            return "[{\"name\": \"Repo Name\"}]".data(using: String.Encoding.utf8)!
        case .updateDeviceProp(_):
            return "[{\"name\": \"Repo Name\"}]".data(using: String.Encoding.utf8)!
        case .checkDevice(_):
            return "[{\"name\": \"Repo Name\"}]".data(using: String.Encoding.utf8)!
        case .resetDevice(_):
            return "[{\"name\": \"Repo Name\"}]".data(using: String.Encoding.utf8)!
        case .sendDeviceAction(_):
            return "[{\"name\": \"Repo Name\"}]".data(using: String.Encoding.utf8)!
        default:
            return "[{\"name\": \"Repo Name\"}]".data(using: String.Encoding.utf8)!
        }
    }
    
    

    
    
}

public struct JsonArrayEncoding: Moya.ParameterEncoding {
    
    public static var `default`: JsonArrayEncoding { return JsonArrayEncoding() }
    
    
    /// Creates a URL request by encoding parameters and applying them onto an existing request.
    ///
    /// - parameter urlRequest: The request to have parameters applied.
    /// - parameter parameters: The parameters to apply.
    ///
    /// - throws: An `AFError.parameterEncodingFailed` error if encoding fails.
    ///
    /// - returns: The encoded request.
    public func encode(_ urlRequest: URLRequestConvertible, with parameters: Parameters?) throws -> URLRequest {
        var req = try urlRequest.asURLRequest()
        let json = try JSONSerialization.data(withJSONObject: parameters!["jsonArray"]!, options: JSONSerialization.WritingOptions.prettyPrinted)
        req.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")
        req.httpBody = json
        return req
    }
    
}


public struct JsonArrayObjectEncoding: Moya.ParameterEncoding {
    
    public static var `default`: JsonArrayObjectEncoding { return JsonArrayObjectEncoding() }
    
    
    /// Creates a URL request by encoding parameters and applying them onto an existing request.
    ///
    /// - parameter urlRequest: The request to have parameters applied.
    /// - parameter parameters: The parameters to apply.
    ///
    /// - throws: An `AFError.parameterEncodingFailed` error if encoding fails.
    ///
    /// - returns: The encoded request.
    public func encode(_ urlRequest: URLRequestConvertible, with parameters: Parameters?) throws -> URLRequest {
        var req = try urlRequest.asURLRequest()
        let json = (parameters!["jsonArray"] as! String).data(using: .utf8)
        req.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")
        req.httpBody = json 
        return req
    }
    
}




