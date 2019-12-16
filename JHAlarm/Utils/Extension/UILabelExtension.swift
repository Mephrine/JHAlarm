//
//  UILabelExtension.swift
//  Mwave
//
//  Created by 김제현 on 2018. 1. 15..
//  Copyright © 2018년 김제현. All rights reserved.
//
import UIKit
import SwiftHEXColors

extension UILabel {
    
    func setLineHeight(lineHeight: CGFloat) {
        let text = self.text
        if let text = text {
            let attributeString = NSMutableAttributedString(string: text)
            let style = NSMutableParagraphStyle()
            
            style.lineSpacing = lineHeight
            attributeString.addAttribute(NSAttributedString.Key.paragraphStyle, value: style, range: NSMakeRange(0, text.count))
            self.attributedText = attributeString
        }
    }
    
    func partTextColorChange (fullText: String , changeText: String ) {
        let strNumber: NSString = fullText.lowercased() as NSString
        let range = (strNumber).range(of: changeText.lowercased())
        let attribute = NSMutableAttributedString.init(string: fullText)
        attribute.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor(hex:0x3891ff) ?? .black , range: range)
        self.attributedText = attribute
    }
    
    
    func partTextColorChangeLine (fullText: String , changeText: String, color: UIColor) {
        let strNumber: NSString = fullText.lowercased() as NSString
        let range = (strNumber).range(of: changeText.lowercased())
        if fullText.count > 0 {
        let attribute = NSMutableAttributedString.init(string: fullText)
            attribute.addAttribute(NSAttributedString.Key.foregroundColor, value: color , range: range)
            attribute.addAttribute(NSAttributedString.Key.underlineStyle, value: NSUnderlineStyle.single.rawValue , range: range)
        self.attributedText = attribute
        }
    }
    
    func partTextColorAllChange (fullText: String, changeText: String) {
        do {
            let lowerFullText = fullText.lowercased()
            
            let regex = try NSRegularExpression(pattern: changeText.lowercased(), options: [])
            let fullStringRange = NSRange.init(lowerFullText.startIndex ..< lowerFullText.endIndex, in: lowerFullText)
            let matches = regex.matches(in: lowerFullText, options: [], range: fullStringRange)
            let ranges = matches.map {$0.range}
            
            let attribute = NSMutableAttributedString.init(string: fullText)
            for range in ranges {
                attribute.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor(hex:0x3891ff) ?? .black , range: range)
            }
            
            self.attributedText = attribute
            
        } catch {}
    }
    
    
//    func setUnderLine(){
//        let underlineAttribute = [NSAttributedString.Key.underlineStyle: NSUnderlineStyle.single.rawValue]
//        let underlineAttributedString = NSAttributedString(string: self.text ?? "", attributes: underlineAttribute)
//        self.attributedText = underlineAttributedString
//    }
    
    func getHeight(_ frame: CGRect) -> CGFloat {
        if let rect = attributedText?.boundingRect(with: CGSize(width: frame.width, height: CGFloat(MAXFLOAT)), options: .usesFontLeading, context: nil) {
            return rect.size.height
        } else {
            return 0
        }
    }
    
    func getWidth() -> CGFloat {
        if let rect = attributedText?.boundingRect(with: CGSize(width: CGFloat(MAXFLOAT), height: CGFloat(MAXFLOAT)), options: .usesLineFragmentOrigin, context: nil) {
            return rect.size.width
        } else {
            return 0
        }
    }
    
    func getHeight() -> CGFloat {
        if let rect = attributedText?.boundingRect(with: CGSize(width: CGFloat(MAXFLOAT), height: CGFloat(MAXFLOAT)), options: .usesLineFragmentOrigin, context: nil) {
            return rect.size.height
        } else {
            return 0
        }
    }
    
    //일정 영역 폰트 변경.
    func partTextColorChange (changeText: String, color: UIColor, font: UIFont? = nil) {
        var lFont: UIFont! = self.font
        if let getFont = font {
            lFont = getFont
        }
        if let fullText = self.text {
            let strNumber: NSString = fullText.lowercased() as NSString
            let range = (strNumber).range(of: changeText.lowercased())
            let attribute = NSMutableAttributedString.init(string: fullText)
            attribute.addAttribute(NSAttributedString.Key.foregroundColor, value: color, range: range)
            attribute.addAttribute(NSAttributedString.Key.font, value: lFont, range: range)
            self.attributedText = attribute
        }
        
    }

    
    func setUnderLine() {
        guard let text = text else { return }
        let textRange = NSMakeRange(0, text.count)
        
        var attributedText = NSMutableAttributedString(string: text)
        
        if let attributed = self.attributedText {
            attributedText = attributed as! NSMutableAttributedString
        }
        
        attributedText.addAttribute(NSAttributedString.Key.underlineStyle , value: NSUnderlineStyle.single.rawValue, range: textRange)
        
        if let textColor = self.textColor {
            attributedText.addAttribute(NSAttributedString.Key.foregroundColor, value: textColor, range: textRange)
        }
        
        if let textFont = self.font {
            attributedText.addAttribute(NSAttributedString.Key.font, value: textFont, range: textRange)
        }
        
        // Add other attributes if needed
        self.attributedText = attributedText
    }
    
    func setLineSpacing(_ spacing: CGFloat) {
        guard let text = text else { return }
        let textRange = NSMakeRange(0, text.count)
        
        var attributedText = NSMutableAttributedString(string: text)
        
        if let attributed = self.attributedText {
            attributedText = attributed as! NSMutableAttributedString
        }
        
        let style = NSMutableParagraphStyle()
        style.lineSpacing = spacing
        attributedText.addAttribute(NSAttributedString.Key.paragraphStyle , value: style, range: textRange)
        
        if let textColor = self.textColor {
            attributedText.addAttribute(NSAttributedString.Key.foregroundColor, value: textColor, range: textRange)
        }
        
        if let textFont = self.font {
            attributedText.addAttribute(NSAttributedString.Key.font, value: textFont, range: textRange)
        }
        
        
        self.attributedText = attributedText
    }
    
    func setLineSpacing(lineSpacing: CGFloat = 0.0, lineHeightMultiple: CGFloat = 0.0) {
        
        guard let labelText = self.text else { return }
        
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = lineSpacing
        paragraphStyle.lineHeightMultiple = lineHeightMultiple
        
        let attributedString:NSMutableAttributedString
        if let labelattributedText = self.attributedText {
            attributedString = NSMutableAttributedString(attributedString: labelattributedText)
        } else {
            attributedString = NSMutableAttributedString(string: labelText)
        }
        
        attributedString.addAttribute(NSAttributedString.Key.paragraphStyle, value:paragraphStyle, range:NSMakeRange(0, attributedString.length))
        
        self.attributedText = attributedString
    }
    
    func setFontSemiBold(_ size: CGFloat, _ color: UIColor? = nil) {
        self.setFontColor(color)
        self.font = UIFont(name: FontName.semiBold.rawValue, size: size)
    }
    
    func setFontBold(_ size: CGFloat, _ color: UIColor? = nil) {
        self.setFontColor(color)
        self.font = UIFont(name: FontName.bold.rawValue, size: size)
    }
    
    func setFontMedium(_ size: CGFloat, _ color: UIColor? = nil) {
        self.setFontColor(color)
        self.font = UIFont(name: FontName.medium.rawValue, size: size)
    }
    
    func setFontRegular(_ size: CGFloat, _ color: UIColor? = nil) {
        self.setFontColor(color)
        self.font = UIFont(name: FontName.regular.rawValue, size: size)
    }
    
    private func setFontColor(_ color: UIColor?) {
        if let fontColor = color {
            self.textColor = fontColor
        }
    }
}
