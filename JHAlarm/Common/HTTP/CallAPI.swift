//
//  CallAPI.swift
//  JHAlarm
//
//  Created by 김제현 on 24/09/2019.
//  Copyright © 2019 김제현. All rights reserved.
//

import Foundation
import RxSwift
import Moya
import Alamofire
import SwiftyJSON


let callProvider = MoyaProvider<CallAPI>()

enum CallAPI {
    case GetWeather(lat: String, lon: String)
    case GetObject
}

extension CallAPI: JSONMappableTargetType {
    // 각 case의 도메인
    var baseURL: URL {
        switch self {
        case .GetWeather:
            return URL(string: W_DOMAIN)!
        default:
            return URL(string: DOMAIN)!
        }
    }
    
    // 각 case의 URL Path
    var path: String {
        switch self {
            case .GetWeather(_, _):
                return "/data/2.5/weather"
            case .GetObject:
                return "/get"
        }
        
        /* example
         case .Component(_, _, _):
         return "/api/comp/IfCom001"
         */
    }
    
    var task: Task {
        
        /* example
         Body로 보내는 거면 하단 처럼 따로 설정.
         
         case .MAMAVoteSend(let bodyRequest):
                    return Task.requestCompositeData(bodyData: bodyRequest.data(using:.utf8)!, urlParameters: [:])
        */
        return .requestParameters(parameters: parameters ?? [:], encoding: parameterEncoding)
    }
    
    // 각 case의 메소드 타입 get / post
    var method: Moya.Method {
        switch self {
        default:
            return .get
        }
    }
    
    // 테스트용도로 제공하는 데이터. 로컬에 json파일 넣고 해당 파일명으로 설정해주면 사용 가능.
    var sampleData: Data {
        return stubbedResponseFromJSONFile(filename: "object_response")
    }
    
    var responseType: ALSwiftyJSONAble.Type {
        switch self {
        case .GetWeather:
            return Weather.self
        default:
            return Weather.self
        }
    }
    
    // 헤더
    var headers: [String: String]? {
        switch self {
        default :
            return nil
        }
    }
    
    // 파라미터
    var parameters: [String: Any]? {
        switch self {
        case .GetWeather(let lat, let lon):
            return ["lat": lat, "lon": lon, "appid": "7af0f9566df99bbd8c44509bcb4d72e2"]
        default :
            return nil
        }
    }
    
    
    var authorizationType: AuthorizationType {
        /*
         밑에와 같은 방식도 있음.
         case .MwaveVoteSend:
         return .bearer
         */
        switch self {
        default:
            return .none
        }
    }
    
    var parameterEncoding: ParameterEncoding {
        /* 아래와 같이도 사용 가능.
         case .sendChatData:
         return URLEncoding.httpBody
         */
        return URLEncoding.default
    }

    // 파일 전송등 multipart 사용 시 사용.
    var multipartBody: [Moya.MultipartFormData]? {
        return nil
    }
}

protocol JSONMappableTargetType: TargetType, AccessTokenAuthorizable {
    var responseType: ALSwiftyJSONAble.Type { get }
}

private func stubbedResponseFromJSONFile(filename: String, inDirectory subpath: String = "", bundle:Bundle = Bundle.main ) -> Data {
    guard let path = bundle.path(forResource: filename, ofType: "json", inDirectory: subpath) else { return Data() }
    
    if let dataString = try? String(contentsOfFile: path), let data = dataString.data(using: String.Encoding.utf8){
        return data
    } else {
        return Data()
    }
}

struct JsonArrayEncoding: Moya.ParameterEncoding {
    
    public static var `default`: JsonArrayEncoding { return JsonArrayEncoding() }

    
    public func encode(_ urlRequest: URLRequestConvertible, with parameters: Parameters?) throws -> URLRequest {
        var req = try urlRequest.asURLRequest()
        let json = try JSONSerialization.data(withJSONObject: parameters!["jsonArray"]!, options: JSONSerialization.WritingOptions.prettyPrinted)
        req.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")
        req.httpBody = json
        return req
    }
    
}
