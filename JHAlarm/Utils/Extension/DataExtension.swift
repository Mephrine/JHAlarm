//
//  DataExtension.swift
//  Mwave
//
//  Created by 김제현 on 2018. 3. 9..
//  Copyright © 2018년 김제현. All rights reserved.
//

import Foundation


extension Data
{
    func toString() -> String
    {
        return String(data: self, encoding: .utf8)!
    }
}
