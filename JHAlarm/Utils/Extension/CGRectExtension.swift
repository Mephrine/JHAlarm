//
//  CGRectExtension.swift
//  JHAlarm
//
//  Created by 김제현 on 09/09/2019.
//  Copyright © 2019 김제현. All rights reserved.
//

extension CGRect {
    var x: CGFloat { return self.origin.x }
    var y: CGFloat { return self.origin.y }
    var centerX: CGFloat { return self.midX }
    var centerY: CGFloat { return self.midY }
    var center: CGPoint { return CGPoint(x: self.midX, y: self.midY) }
}
