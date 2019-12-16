//
//  UIStackViewExtension.swift
//  JHAlarm
//
//  Created by 김제현 on 09/09/2019.
//  Copyright © 2019 김제현. All rights reserved.
//

import Foundation

public extension UIStackView {
    func removeAllArrangedSubview() {
        arrangedSubviews.forEach({ child in
            self.removeArrangedSubview(child)
            child.removeFromSuperview()
        })
    }
}

