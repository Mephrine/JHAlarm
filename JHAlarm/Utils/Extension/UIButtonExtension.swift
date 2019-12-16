//
//  UIButtonExtension.swift
//  Mwave
//
//  Created by MinHyuk Lee on 2017. 11. 1..
//  Copyright © 2017년 김제현. All rights reserved.
//

import UIKit
import RxSwift

extension UIButton {
    func underline() {
        let attributedString = NSMutableAttributedString(string: (self.titleLabel?.text!)!)
        attributedString.addAttribute(NSAttributedString.Key.underlineStyle, value: NSUnderlineStyle.single.rawValue, range: NSRange(location: 0, length: (self.titleLabel?.text!.count)!))
        self.setAttributedTitle(attributedString, for: .normal)
    }
    
    func removeUnderLine() {
        let attributedString = NSMutableAttributedString(string: (self.titleLabel?.text!)!)
        attributedString.removeAttribute(NSAttributedString.Key.underlineStyle, range: NSRange(location: 0, length: (self.titleLabel?.text!.count)!))
        self.setAttributedTitle(attributedString, for: .normal)
    }
    
    
    func partTextColorChangeLine (fullText: String , changeText: String, fontColor: UIColor, lineColor: UIColor ) {
        let strNumber: NSString = fullText.lowercased() as NSString
        let range = (strNumber).range(of: changeText.lowercased())
        if fullText.count > 0 && changeText.count > 0 {
            let attri = [NSAttributedString.Key.foregroundColor : fontColor]
        let attribute = NSMutableAttributedString(string: fullText,
                                                  attributes: attri)
            
            attribute.addAttribute(NSAttributedString.Key.foregroundColor, value: lineColor , range: range)
        
        
            attribute.addAttribute(NSAttributedString.Key.underlineStyle, value: NSUnderlineStyle.single.rawValue , range: range)
        self.setAttributedTitle(attribute, for: .normal)
        }
    }
    
    func whenTouchUpInside(throttle dueTime: TimeInterval = 0.3) -> Observable<UIButton> {
        return rx.tap.asDriver()
            .throttle(dueTime, latest: false)
            .map({ self })
            .asObservable()
    }
    
}



extension UILabel {
    func underline() {
        if let textString = self.text {
            let attributedString = NSMutableAttributedString(string: textString)
            attributedString.addAttribute(NSAttributedString.Key.underlineStyle, value: NSUnderlineStyle.single.rawValue, range: NSRange(location: 0, length: attributedString.length - 1))
            attributedText = attributedString
        }
    }
    
    func resizeingFont(size: Int, isBold: Bool) {
        let fontSize = Int((UIScreen.main.bounds.height * CGFloat(size)) / 667)
        
        if isBold{
            self.font = UIFont.boldSystemFont(ofSize: CGFloat(fontSize))
        } else {
            self.font = UIFont.systemFont(ofSize: CGFloat(fontSize))
        }
        
    }
}
