//
//  UISwitchExtension.swift
//  Mwave
//
//  Created by MinHyuk Lee on 2017. 9. 12..
//  Copyright © 2017년 김제현. All rights reserved.
//

import UIKit
@IBDesignable

class UISwitchExtension: UISwitch {
    @IBInspectable var OffTint: UIColor? {
        didSet {
            self.tintColor = OffTint
            self.layer.cornerRadius = 16
            self.backgroundColor = OffTint
        }
    }
}
