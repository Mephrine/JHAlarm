//
//  JsonExtention.swift
//  Mwave
//
//  Created by MinHyuk Lee on 2017. 9. 22..
//  Copyright © 2017년 김제현. All rights reserved.
//

import Foundation
import SwiftyJSON
import Alamofire

extension JSON {
    func to<T>(type: T?) -> Any? {
        if let baseObj = type as? ALSwiftyJSONAble.Type {
            if self.type == .array {
                var arrObject: [Any] = []
                for obj in self.arrayValue {
                    let object = baseObj.init(jsonData: obj)
                    arrObject.append(object!)
                }
                return arrObject
            } else {
                let object = baseObj.init(jsonData: self)
                return object!
            }
        }
        return nil
    }
}

