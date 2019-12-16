//
//  RoundView.swift
//  Mwave
//
//  Created by 김제현 on 2018. 1. 17..
//  Copyright © 2018년 김제현. All rights reserved.
//

import UIKit
import SwiftHEXColors

@IBDesignable
public class CircleView: UIView {
    
    @IBInspectable
    public var lineColor: UIColor = UIColor(hex: 0xc9c9c9)!
    
    @IBInspectable
    public var lineWidth: CGFloat = CGFloat(8)
    
    override public init(frame: CGRect) {
        super.init(frame: frame)
        initBackgroundColor()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initBackgroundColor()
    }
    
    override public func prepareForInterfaceBuilder() {
        initBackgroundColor()
    }
    
    override public func draw(_ rect: CGRect) {
        
        let halfSize:CGFloat = min( bounds.size.width/2, bounds.size.height/2)
        let desiredLineWidth:CGFloat = 1
        let path = UIBezierPath.init(arcCenter: CGPoint(x: halfSize,y: halfSize), radius: halfSize - (desiredLineWidth/2), startAngle: CGFloat(0), endAngle: CGFloat(CGFloat.pi * 2), clockwise: true)
        
        let shapeLayer = CAShapeLayer()
        shapeLayer.path = path.cgPath
        
        shapeLayer.fillColor = UIColor.clear.cgColor
        shapeLayer.strokeColor = UIColor.clear.cgColor
        shapeLayer.lineWidth = desiredLineWidth
        
        layer.addSublayer(shapeLayer)
        
    }
    
    func initBackgroundColor() {
        if backgroundColor == nil {
            backgroundColor = UIColor.clear
        }
    }
    
}

