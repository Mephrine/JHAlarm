//
//  ArrayExtension.swift
//  Mwave
//
//  Created by 김제현 on 2018. 3. 2..
//  Copyright © 2018년 김제현. All rights reserved.
//

import Foundation

extension Array
{
    func contains<T>(obj: T) -> Bool where T : Equatable {
        return self.filter({$0 as? T == obj}).count > 0
    }
}


extension Array where Element: Equatable {
    
    public func exists(_ item: Element) -> Bool {
        if let _ = self.indexOf(item) {
            return true
        }
        return false
    }
    
    public func indexOf(_ item: Element) -> Int? {
        return self.enumerated().filter({ $0.element == item }).map({ $0.offset }).first
    }
    
    public mutating func remove(item: Element) -> Element? {
        if let index = indexOf(item) {
            return self.remove(at: index)
        }
        return nil
    }
    
    public func removed(_ item: Element) -> [Element] {
        return self.filter({ $0 != item })
    }
    
    public func findAndReplace(_ selector: (Element) -> Bool,
                               replaceWith: (Element) -> Element) -> [Element] {
        return map { item in selector(item) ? replaceWith(item) : item }
    }
}
