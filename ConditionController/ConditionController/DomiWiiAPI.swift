//
//  DomiWiiAPI.swift
//  ConditionController
//
//  Created by Beta 8.0 Technology on 12/10/16.
//  Copyright © 2016 vincenzoOlivito. All rights reserved.
//

import Foundation
import Moya

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


let endpointClosure = { (target: DomiWii) -> Endpoint<DomiWii> in
    let url = target.baseURL.appendingPathComponent(target.path).absoluteString
    var encoding: Moya.ParameterEncoding = JSONEncoding()
    
    switch target.method {
    case Moya.Method.get:
        encoding = URLEncoding()
    default:
        encoding = JSONEncoding()
    }
    
    let endpoint: Endpoint<DomiWii> = Endpoint<DomiWii>(url: url, sampleResponseClosure: {.networkResponse(200, target.sampleData)}, method: target.method, parameters: target.parameters, parameterEncoding: encoding)
    
    return endpoint
}

let DomiWiiProvider = MoyaProvider<DomiWii>(endpointClosure: endpointClosure,
                                            requestClosure: MoyaProvider.defaultRequestMapping,
                                            stubClosure: MoyaProvider.neverStub,
                                            manager: manager,
                                            plugins: [NetworkLoggerPlugin(verbose: true, responseDataFormatter: nil)])

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
}

extension DomiWii: TargetType {
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
        }
    }
    
    public var method: Moya.Method {
        return Moya.Method.post
    }
    
    
    public var parameters: [String: Any]? {
        switch self {
        case .devicesMetadata(let aliases):
            return [ "" : aliases]
        case .sendConditionerAction(let alias, let  mode, let speed, let temperature, let confort):
            return [
                "alias" : alias,
                "mode" : mode,
                "speed": (speed != nil ? speed : "-1" ),
                "temperature": (temperature != nil ? temperature : "-1"),
                "confort": (confort != nil ? confort : "-1")
            ]
        case .updateDeviceProp(let password, let newPassword, let alias, let newAlias):
            return [
                "password" : password,
                "newPassword" : newPassword,
                "alias" : alias,
                "newAlias" : newAlias
            ]
        case .checkDevice(let alias, let password):
            return [
                "alias": "",
                "password": password,
                "uid": alias
            ]
        case .resetDevice(let alias, let password):
            return [
                "alias":alias,
                "newAlias": "",
                "password": password,
                "newPassword": ""
            ]
            
        default:
            return nil
        }
    }
    
    public var parameterEncoding: ParameterEncoding  {
     return URLEncoding.default;
    }
    
    
    public var task: Task {
        return .request
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
        }
    }
}

