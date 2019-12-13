//
//  CommonHttp.swift
//  JHAlarm
//
//  Created by 김제현 on 24/09/2019.
//  Copyright © 2019 김제현. All rights reserved.
//

import Foundation
import RxSwift
import Moya

enum CommonHttp {
    case getWeather(Void)
}

let callProvider: MoyaProvider<CallAPI>()

extension CallAPI: TargetType {
    var baseURL: URL { return URL(string: DOMAIN)! }
    var path: String {
        switch self {
            case.getWeather()
                return "/abcd"
        }
    }
    
    var method: Moya.Method {
        switch self {
            default:
                return .get
        }
    }
    
    var parameters: [String: Any]? {
        switch self {
        default :
            return nil
        }
    }
    
    var task: Task {
        return .request
    }
    
    var parameterEncoding: ParameterEncoding {
        return JSONEncoding.default
    }
    
    static func getRepo(_repo: String) -> Single<[String: Any]> {
        return Single<[String: Any]>.create { single in
            
            
            return Disposables.create {  }
        }
    }
}
