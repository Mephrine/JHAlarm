//
//  NSObjectExtension.swift
//  JHAlarm
//
//  Created by 김제현 on 12/08/2019.
//  Copyright © 2019 김제현. All rights reserved.
//

import UIKit

extension NSObject {
    var className: String {
        return NSStringFromClass(self.classForCoder).components(separatedBy: ".").last!;
    }
    
    func getViewController(fromStoryboard storyboard: String, identifier: String) -> UIViewController? {
        let bundle = Bundle(for: self.classForCoder)
        
        let sb = UIStoryboard(name: storyboard, bundle: bundle)
        
        return sb.instantiateViewController(withIdentifier: identifier)
    }
}

