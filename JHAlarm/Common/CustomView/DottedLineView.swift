//
//  dashedLine.swift
//  Mwave
//
//  Created by 김제현 on 2018. 1. 16..
//  Copyright © 2018년 김제현. All rights reserved.
//

import UIKit
import SwiftHEXColors

@IBDesignable
public class DottedLineView: UIView {
    
    @IBInspectable
    public var lineColor: UIColor = UIColor(hex: 0xc9c9c9)!
    
    @IBInspectable
    public var lineWidth: CGFloat = CGFloat(8)
    
    @IBInspectable
    public var round: Bool = false
    
    @IBInspectable
    public var horizontal: Bool = true
    
    @IBInspectable
    public var isLine: Bool = true
    
    @IBInspectable
    public var isRect: Bool = true
    
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
        
        let path = UIBezierPath()
        path.lineWidth = lineWidth
        
        if isLine {
            if round {
                configureRoundPath(path: path, rect: rect)
            } else {
                configurePath(path: path, rect: rect)
            }
        } else if isRect {
            configureRect(rect: rect)
        } else {
            configureCircle(rect: rect)
        }
        lineColor.setStroke()
        
        path.stroke()
    }
    
    func initBackgroundColor() {
        if backgroundColor == nil {
            backgroundColor = UIColor.clear
        }
    }
    
    private func configurePath(path: UIBezierPath, rect: CGRect) {
        if horizontal {
            let center = rect.height * 0.5
            let rWidth = rect.size.width.truncatingRemainder(dividingBy: lineWidth * 2)
            let drawWidth = rect.size.width - rWidth + lineWidth
            let startPositionX = (rect.size.width - drawWidth) * 0.5 + lineWidth
            
            path.move(to: CGPoint(x: startPositionX, y: center))
            path.addLine(to: CGPoint(x: drawWidth, y: center))
            
        } else {
            let center = rect.width * 0.5
            let rHeight = rect.size.height.truncatingRemainder(dividingBy: lineWidth)
            let drawHeight = rect.size.height - rHeight + lineWidth
            let startPositionY = (rect.size.height - drawHeight) * 0.5 + lineWidth
            
            path.move(to: CGPoint(x: center, y: startPositionY))
            path.addLine(to: CGPoint(x: center, y: drawHeight))
        }
        
        let dashes: [CGFloat] = [lineWidth, lineWidth]
        path.setLineDash(dashes, count: dashes.count, phase: 0)
        path.lineCapStyle = CGLineCap.butt
        path.lineWidth = 1
    }
    
    private func configureRoundPath(path: UIBezierPath, rect: CGRect) {
        if horizontal {
            let center = rect.height * 0.5
            let rWidth = rect.size.width.truncatingRemainder(dividingBy: lineWidth * 2)
            let drawWidth = rect.size.width - rWidth
            let startPositionX = (rect.size.width - drawWidth) * 0.5 + lineWidth
            
            path.move(to: CGPoint(x: startPositionX, y: center))
            path.addLine(to: CGPoint(x: drawWidth, y: center))
            
        } else {
            let center = rect.width * 0.5
            let rHeight = rect.size.height.truncatingRemainder(dividingBy: lineWidth * 2)
            let drawHeight = rect.size.height - rHeight
            let startPositionY = (rect.size.height - drawHeight) * 0.5 + lineWidth
            
            path.move(to: CGPoint(x: center, y: startPositionY))
            path.addLine(to: CGPoint(x: center, y: drawHeight))
        }
        
        let dashes: [CGFloat] = [0, lineWidth * 2]
        path.setLineDash(dashes, count: dashes.count, phase: 0)
        path.lineCapStyle = CGLineCap.round
    }
    
    
    private func configureRect(rect: CGRect){
        
        let yourViewBorder = CAShapeLayer()
        yourViewBorder.strokeColor = UIColor(hex: 0xc9c9c9)?.cgColor
        yourViewBorder.lineDashPattern = [8, 4]
        yourViewBorder.frame = self.bounds
        yourViewBorder.fillColor = nil
        yourViewBorder.lineWidth = 2
        
        let path = UIBezierPath.init(roundedRect: self.bounds, cornerRadius: 7)
        
        
        let dashes: [CGFloat] = [lineWidth, lineWidth]
        path.setLineDash(dashes, count: dashes.count, phase: 0)
        path.lineCapStyle = CGLineCap.butt
        
        yourViewBorder.path = path.cgPath
        self.layer.addSublayer(yourViewBorder)
    }
    
    private func configureCircle(rect: CGRect){
        
        let yourViewBorder = CAShapeLayer()
        yourViewBorder.strokeColor = UIColor(hex: 0xc9c9c9)?.cgColor
        yourViewBorder.lineDashPattern = [8, 4]
        yourViewBorder.frame = self.bounds
        yourViewBorder.fillColor = nil
        yourViewBorder.lineWidth = 2
        
//        let path = UIBezierPath.init(roundedRect: self.bounds, cornerRadius: 7)
        let halfSize:CGFloat = min( bounds.size.width/2, bounds.size.height/2)
        let desiredLineWidth:CGFloat = 1
        let path = UIBezierPath.init(arcCenter: CGPoint(x: halfSize,y: halfSize), radius: halfSize - (desiredLineWidth/2), startAngle: CGFloat(0), endAngle: CGFloat(CGFloat.pi * 2), clockwise: true)
        
        
        let dashes: [CGFloat] = [lineWidth, lineWidth]
        path.setLineDash(dashes, count: dashes.count, phase: 0)
        path.lineCapStyle = CGLineCap.butt
        
        yourViewBorder.path = path.cgPath
        self.layer.addSublayer(yourViewBorder)
    }
    
}
