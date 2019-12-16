//
//  NSMutableAttributeStringExtension.swift
//  JHAlarm
//
//  Created by 김제현 on 12/08/2019.
//  Copyright © 2019 김제현. All rights reserved.
//

import UIKit
extension NSMutableAttributedString {
    
    func setColorForText(textForAttribute: String, withColor color: UIColor) {
        let range: NSRange = self.mutableString.range(of: textForAttribute, options: .caseInsensitive)
        let range2: NSRange = NSRange.init(location: 0, length: 0)
        
        if range != range2 {
            // Swift 4.2 and above
            //            self.addAttribute(NSAttributedString.Key.foregroundColor, value: color, range: range)
            
            // Swift 4.1 and below
            self.addAttribute(NSAttributedString.Key.foregroundColor, value: color, range: range)
        }
    }
}
