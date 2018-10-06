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

let endpointClosureDevice = { (target: DomiWiiDevice) -> Endpoint in
    //let url = target.baseURL.appendingPathComponent(target.path).absoluteString
//    var encoding: Moya.ParameterEncoding = URLEncoding()
//
//    switch target.method {
//    case Moya.Method.get:
//        encoding = URLEncoding()
//    default:
//        encoding = URLEncoding()
//        //encoding = JsonArrayEncoding()
//    }
//    let url = target.baseURL.absoluteString + target.path
    let url = URL(target: target).absoluteString
    return Endpoint(url: url, sampleResponseClosure: {.networkResponse(200, target.sampleData)}, method: target.method, task: target.task, httpHeaderFields: target.headers)
}

//let requestClosure = { (endpoint: Endpoint, done: MoyaProvider.RequestResultClosure) in
//    do{
//        var request = try endpoint.urlRequest()
//        // Modify the request however you like.
//        done(.success(request))
//    }
//    catch{
//        done(.failure(MoyaError.underlying(error, <#Response?#>)))
//    }
//
//}



//let DomiWiiDeviceProvider = MoyaProvider<DomiWiiDevice>(endpointClosure: endpointClosureDevice,
//                                            requestClosure: MoyaProvider<DomiWiiDevice>.defaultRequestMapping,
//                                            stubClosure: MoyaProvider.neverStub,
//                                            manager: managerDevice,
//                                            plugins: [NetworkLoggerPlugin(verbose: true, responseDataFormatter: nil)])

let DomiWiiDeviceProvider = MoyaProvider<DomiWiiDevice>(manager: DefaultAlamofireManager.sharedManager, plugins:[NetworkLoggerPlugin(verbose: true, responseDataFormatter: nil)])


// MARK: - Provider support

private extension String {
    var urlEscaped: String {
        return self.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)!
    }
}

public enum DomiWiiDevice {
    case startControlMode()
    case endControlMode()
    case activateDevice(ssidHomeNetwork: String, password: String, ipStatico: String, mask: String, ipRouter : String, dnsPrimario : String)
    case registerDevice(count: String, codes: String)
    case testCommand(commandCode: String)
    case manualActivationCommand(commandCode: String)
}

extension DomiWiiDevice: TargetType {
    
    
    
    //public var baseURL: URL { return URL(string: "http://192.168.4.1:8090")! }
    
    public var baseURL: URL {
        
        var url = "http://192.168.4.1:8090"
        
        switch self {
        case .startControlMode:
            url += "?0?1?"
        case .endControlMode:
            url +=  "?0?0?"
        case .activateDevice(let ssidHomeNetwork, let password, let ipStatico, let mask, let ipRouter, let dnsPrimario):
            url += "?1?\(ssidHomeNetwork)?\(password)?\(ipStatico)?\(mask)?\(ipRouter)?\(dnsPrimario)"
        case .registerDevice(let count, let codes):
            let ret = "?C?\(count)?\(codes)?"
            url += ret
        case .testCommand(let commandCode):
            url += "?T?\(commandCode)?"
        case .manualActivationCommand(let commandCode):
            url += "?3?\(commandCode)?"
        }
        
        return URL(string: url.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)!)!
    }
    
    public var path : String {return ""}
    
    public var method: Moya.Method {
        return .get
    }
    
    

    public var parameterEncodingCustom: Moya.ParameterEncoding {
        return URLEncoding.default;
 //        switch self {
//        case .addContact(let bodyParam):
//
//            return ParameterEncoding.Custom(MyAPICallCustomEncodingClosure)
//        }
    }

    
    
    
    public var task: Task {
        return .requestPlain
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
    
    public var headers: [String : String]? {
        return ["Content-Type": "application/json"]
    }
}

