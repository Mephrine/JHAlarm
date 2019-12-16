//
//  RoundButton.swift
//  Mwave
//
//  Created by 김제현 on 2018. 3. 6..
//  Copyright © 2018년 김제현. All rights reserved.
//

import UIKit

@IBDesignable class RoundButton: UIButton
{
    override func layoutSubviews() {
        super.layoutSubviews()
        
        updateCornerRadius()
    }
    
    @IBInspectable var rounded: Bool = false {
        didSet {
            updateCornerRadius()
        }
    }
    
    func updateCornerRadius() {
        layer.cornerRadius = rounded ? frame.size.height / 2 : 0
    }
}
