//
//  InsetTextField.swift
//  Mwave
//
//  Created by 김제현 on 2018. 3. 5..
//  Copyright © 2018년 김제현. All rights reserved.
//

import UIKit

@IBDesignable
class InsetTextField: UITextField {
    
    @IBInspectable var insetX: CGFloat = 0
    @IBInspectable var insetY: CGFloat = 0
    
    override func textRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.insetBy(dx: insetX, dy: insetY)
    }
    
    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        return textRect(forBounds: bounds)
    }
    
}
