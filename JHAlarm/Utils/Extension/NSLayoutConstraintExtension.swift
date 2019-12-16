//
//  NSLayoutConstraintExtension.swift
//  Mwave
//
//  Created by 김제현 on 2017. 8. 28..
//  Copyright © 2017년 김제현. All rights reserved.
//


import UIKit

extension NSLayoutConstraint {
    func constraintWithMultiplier(_ multiplier: CGFloat) -> NSLayoutConstraint {
        return NSLayoutConstraint(item: self.firstItem, attribute: self.firstAttribute, relatedBy: self.relation, toItem: self.secondItem, attribute: self.secondAttribute, multiplier: multiplier, constant: self.constant)
    }
    
    
  }
