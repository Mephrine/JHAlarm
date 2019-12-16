//
//  UIViewExtension.swift
//  Mwave
//
//  Created by 김제현 on 2017. 8. 30..
//  Copyright © 2017년 김제현. All rights reserved.
//

import UIKit
import RxSwift

extension UIView
{
    func copyView<T: UIView>() -> T {
        return NSKeyedUnarchiver.unarchiveObject(with: NSKeyedArchiver.archivedData(withRootObject: self)) as! T
    }
    
    func addConstrainsWithFormat(format: String, views: UIView...) {
        var viewsDictionary = [String: UIView]()
        for (index, view) in views.enumerated() {
            let key = "v\(index)"
            viewsDictionary[key] = view
            view.translatesAutoresizingMaskIntoConstraints = false
        }
        
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: format, options: NSLayoutConstraint.FormatOptions(), metrics: nil, views: viewsDictionary))
    }
    
    @IBInspectable var cornerRadius: CGFloat {
        get {
            return layer.cornerRadius
        }
        set {
            layer.cornerRadius = newValue
            layer.masksToBounds = newValue > 0
        }
    }
    
    @IBInspectable var borderWidth: CGFloat {
        get {
            return layer.borderWidth
        }
        set {
            layer.borderWidth = newValue
        }
    }
    
    @IBInspectable var borderColor: UIColor? {
        get {
            return UIColor(cgColor: layer.borderColor!)
        }
        set {
            layer.borderColor = newValue?.cgColor
        }
    }
    
    func fadeTransition(_ duration:CFTimeInterval) {
        let animation = CATransition()
        animation.timingFunction = CAMediaTimingFunction(name:
            CAMediaTimingFunctionName.easeInEaseOut)
        animation.type = CATransitionType.fade
        animation.duration = duration
        layer.add(animation, forKey: CATransitionType.fade.rawValue)
    }
    
    func removeAllSubviews() {
        for subview in self.subviews {
            subview.removeFromSuperview()
        }
    }
    func removeAllConstraints() {
        self.removeConstraints(self.constraints)
        for view in self.subviews {
            view.removeAllConstraints()
        }
    }
    
    func parentViewController() -> UIViewController? {
        var parentResponder: UIResponder? = self
        while true {
            guard let nextResponder = parentResponder?.next else { return nil }
            if let vc = nextResponder as? UIViewController {
                return vc
            }
            parentResponder = nextResponder
        }
    }
    
    func addDashedBorder(s: NSNumber, e: NSNumber, lineWidth: CGFloat) {
        let shapeLayer:CAShapeLayer = CAShapeLayer()
        let frameSize = self.frame.size
        let shapeRect = CGRect(x: 0, y: 0, width: frameSize.width, height: frameSize.height)
        
        shapeLayer.bounds = shapeRect
        shapeLayer.position = CGPoint(x: frameSize.width/2, y: frameSize.height/2)
        shapeLayer.fillColor = UIColor.clear.cgColor
        shapeLayer.strokeColor = UIColor(red: 232/255, green: 232/255, blue: 232/255, alpha: 1).cgColor
        shapeLayer.lineWidth = lineWidth
        shapeLayer.lineJoin = CAShapeLayerLineJoin.round
        shapeLayer.lineDashPattern = [s,e]
        shapeLayer.path = UIBezierPath(roundedRect: shapeRect, cornerRadius: 0).cgPath
        
        self.layer.addSublayer(shapeLayer)
    }
    
    func addBorderTop(size: CGFloat, color: UIColor) {
        addBorderUtility(x: 0, y: 0, width: frame.width, height: size, color: color)
    }
    func addBorderBottom(size: CGFloat, color: UIColor) {
        addBorderUtility(x: 0, y: frame.height - size, width: frame.width, height: size, color: color)
    }
    func addBorderLeft(size: CGFloat, color: UIColor) {
        addBorderUtility(x: 0, y: 0, width: size, height: frame.height, color: color)
    }
    func addBorderRight(size: CGFloat, color: UIColor) {
        addBorderUtility(x: frame.width - size, y: 0, width: size, height: frame.height, color: color)
    }
    private func addBorderUtility(x: CGFloat, y: CGFloat, width: CGFloat, height: CGFloat, color: UIColor) {
        let border = CALayer()
        border.backgroundColor = color.cgColor
        border.frame = CGRect(x: x, y: y, width: width, height: height)
        layer.addSublayer(border)
    }
    
    
    func addTapGestureRecognizer(_ numberOfTapsRequired: Int = 1) -> Observable<UITapGestureRecognizer> {
        let tapGesture = UITapGestureRecognizer()
        tapGesture.numberOfTapsRequired = numberOfTapsRequired
        isUserInteractionEnabled = true
        addGestureRecognizer(tapGesture)
        return tapGesture.rx.event.asDriver().asObservable()
    }
    
    func addSwipeGestureRecognizer() -> Observable<UISwipeGestureRecognizer> {
        let swipeGesture = UISwipeGestureRecognizer()
        isUserInteractionEnabled = true
        addGestureRecognizer(swipeGesture)
        return swipeGesture.rx.event.asDriver().asObservable()
    }
}


@IBDesignable
public extension UIView {
    @IBInspectable
    var shadowColor: UIColor? {
        set {
            layer.shadowColor = newValue!.cgColor
        }
        get {
            if let color = layer.shadowColor {
                return UIColor(cgColor: color)
            } else {
                return nil
            }
        }
    }
    
    @IBInspectable
    var shadowOpacity: Float {
        set {
            layer.shadowOpacity = newValue
        }
        get {
            return layer.shadowOpacity
        }
    }
    
    @IBInspectable
    var masksToBounds: Bool {
        set {
            layer.masksToBounds = newValue
        }
        get {
            return layer.masksToBounds
        }
    }
    
    @IBInspectable
    var shadowRadius: CGFloat {
        set {
            layer.shadowRadius = newValue
        }
        get {
            return layer.shadowRadius
        }
    }
    
    @IBInspectable
    var shadowOffset: CGSize {
        set {
            layer.shadowOffset = newValue
        }
        get {
            return layer.shadowOffset
        }
    }
    
    var isShown: Bool {
        get {
            return !isHidden
        }
        set {
            isHidden = !newValue
        }
    }
}

extension UIView {
    var centerX: CGFloat { return self.center.x }
    var centerY: CGFloat { return self.center.y }
    
    func calcAbsoluteRectInScreen() -> CGRect {
        var rect = self.frame
        var superView = self.superview
        while(superView != nil) {
            let ssuperView = superView!.superview
            if ssuperView == nil { break }
            
            rect = superView!.convert(rect, to: ssuperView!)
            superView = ssuperView
        }
        return rect
    }
}

extension UIView {
    func viewWithIdentifier(_ identifier: String) -> UIView? {
        if identifier == accessibilityIdentifier { return self }
        for v in subviews {
            let sub = v.viewWithIdentifier(identifier)
            if sub != nil { return sub }
        }
        return nil
    }
    
    func constraintWithIdentifier(_ identifier: String) -> NSLayoutConstraint? {
        var searchView: UIView? = self
        while searchView != nil {
            for constraint in searchView!.constraints as [NSLayoutConstraint] {
                if constraint.identifier == identifier {
                    return constraint
                }
            }
            searchView = searchView!.superview
        }
        return nil
    }
        
    func imageView(_ tag: Int) -> UIImageView? {
        return viewWithTag(tag) as? UIImageView
    }
    
    func label(_ tag: Int) -> UILabel? {
        return viewWithTag(tag) as? UILabel
    }
    
    func button(_ tag: Int) -> UIButton? {
        return viewWithTag(tag) as? UIButton
    }
    
    func textfield(_ tag: Int) -> UITextField? {
        return viewWithTag(tag) as? UITextField
    }
}
