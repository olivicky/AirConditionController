//
//  DomiWiiDeviceAPI.swift
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

let managerDevice = Manager(
    configuration: URLSessionConfiguration.default
)


//let endpointClosureDevice = { (target: DomiWiiDevice) -> Endpoint<DomiWiiDevice> in
//    let url = target.baseURL.appendingPathComponent(target.path).absoluteString
//    var encoding: Moya.ParameterEncoding = JSONEncoding()
//    
//    switch target.method {
//    case Moya.Method.get:
//        encoding = JSONEncoding()
//    default:
//        encoding = JSONEncoding()
//    }
//    
//    let endpoint: Endpoint<DomiWiiDevice> = Endpoint<DomiWiiDevice>(URL: url, sampleResponseClosure: {.networkResponse(200, target.sampleData)}, method: target.method, parameters: target.parameters, parameterEncoding: encoding)
//    
//    return endpoint
//}

let endpointClosureDevice = { (target: DomiWiiDevice) -> Endpoint<DomiWiiDevice> in
    let url = target.baseURL.absoluteString + target.path
    return Endpoint(url: url, sampleResponseClosure: {.networkResponse(200, target.sampleData)}, method: target.method, parameters: target.parameters)
}

let requestClosure = { (endpoint: Endpoint<DomiWiiDevice>, done: MoyaProvider.RequestResultClosure) in
    var request = endpoint.urlRequest! as URLRequest
    // Modify the request however you like.
    done(.success(request))
}



let DomiWiiDeviceProvider = MoyaProvider<DomiWiiDevice>(endpointClosure: endpointClosureDevice,
                                            requestClosure: MoyaProvider.defaultRequestMapping,
                                            stubClosure: MoyaProvider.neverStub,
                                            manager: managerDevice,
                                            plugins: [NetworkLoggerPlugin(verbose: true, responseDataFormatter: nil)])

// MARK: - Provider support

private extension String {
    var urlEscaped: String {
        return self.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)!
    }
}

public enum DomiWiiDevice {
    case startControlMode()
    case endControlMode()
    case activateDevice(ssidHomeNetwork: String, password: String, ipStatico: String?, mask: String?, ipRouter : String?, dnsPrimario : String?)
    case registerDevice(count: String, codes: String)
    case testCommand(commandCode: String)
    case manualActivationCommand(commandCode: String)
}

extension DomiWiiDevice: TargetType {
    public var baseURL: URL { return URL(string: "http://192.168.4.1:8090")! }
    public var path: String {
        switch self {
        case .startControlMode:
            return "?0?1?"
        case .endControlMode:
            return  "?0?0"
        case .activateDevice(let ssidHomeNetwork, let password, _,_,_,_):
            return "?1?\(ssidHomeNetwork)?\(password)?\(0)?\(0)?\(0)?\(0)"
        case .registerDevice(let count, let codes):
            return "?C?\(count)?\(codes)"
        case .testCommand(let commandCode):
            return "?T?\(commandCode)?"
        case .manualActivationCommand(let commandCode):
            return "?3?\(commandCode)?"
        }
    }
    
    public var method: Moya.Method {
        return Moya.Method.get
    }
    
    
    public var parameters: [String: Any]? {
        switch self {
//        case .startControlMode():
//            return [:]
//        case .endControlMode():
//            return [:]
//        case .activateDevice(let ssidHomeNetwork, let password, let ipStatico, let mask, let ipRouter, let dnsPrimario):
//            return [:]
////            return [
////            "": ssidHomeNetwork,
////            "": password,
////            "": ipStatico ?? "0",
////            "": mask ??  "0",
////            "": ipRouter ?? "0",
////            "": dnsPrimario ?? "0"
////            ]
//            
//        case .registerDevice(let count, let codes):
//            return [:]
////            return [count:
////                    codes]
//        case .testCommand(let commandCode):
//            return [:]
////            return ["code" : commandCode]
//        case .manualActivationCommand(let commandCode):
//            return [:]
////            return ["code" : commandCode]
//            
        default:
            return nil
        }
    }
    

    public var parameterEncoding: Moya.ParameterEncoding {
        return URLEncoding.default;
//        switch self {
//        case .addContact(let bodyParam):
//            
//            return ParameterEncoding.Custom(MyAPICallCustomEncodingClosure)
//        }
    }

    
    
    
    public var task: Task {
        return .request
    }
    public var sampleData: Data {
        switch self {
        case .startControlMode:
            return "Half measures are as bad as nothing at all.".data(using: String.Encoding.utf8)!
        case .endControlMode:
            return "Half measures are as bad as nothing at all.".data(using: String.Encoding.utf8)!
        case .activateDevice(_):
            return "[{\"name\": \"Repo Name\"}]".data(using: String.Encoding.utf8)!
        case .registerDevice(_,_):
            return "Half measures are as bad as nothing at all.".data(using: String.Encoding.utf8)!
        case .testCommand(_):
            return "[{\"name\": \"Repo Name\"}]".data(using: String.Encoding.utf8)!
        case .manualActivationCommand(_):
            return "[{\"name\": \"Repo Name\"}]".data(using: String.Encoding.utf8)!
        }
    }
}

