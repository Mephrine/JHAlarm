//
//  BGColorButton.swift
//  Mwave
//
//  Created by 김제현 on 2018. 3. 6..
//  Copyright © 2018년 김제현. All rights reserved.
//

import UIKit


class BGCollorButton: UIButton {
    @IBInspectable var highlightedBackgroundColor :UIColor?
    @IBInspectable var nonHighlightedBackgroundColor :UIColor?
    override var isHighlighted :Bool {
        get {
            return super.isHighlighted
        }
        set {
            if newValue {
                self.backgroundColor = highlightedBackgroundColor
            }
            else {
                self.backgroundColor = nonHighlightedBackgroundColor
            }
            super.isHighlighted = newValue
        }
    }
    
    
    
}
