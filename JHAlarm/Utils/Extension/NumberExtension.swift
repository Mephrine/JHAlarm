//
//  NumberExtension.swift
//  Mwave
//
//  Created by 김제현 on 2017. 10. 6..
//  Copyright © 2017년 김제현. All rights reserved.
//

import Foundation

extension CGFloat {
    // iPhone8 너비 기준.
    func resolutionFontSize() -> CGFloat {
        let size_formatter = self / 375
        let screenWidth = UIScreen.main.bounds.size.width
        let result = screenWidth * size_formatter
        return result
    }
}

extension Double {
    func roundToPlaces(places:Int) -> Double {
        let divisor = pow(10.0, Double(places))
        return Darwin.round(self * divisor) / divisor
    }

    var array: [Double] {
        return String(self).flatMap{ Double(String($0)) }
    }
    
    // 소숫점 2자리
    var toDecimal: String {
        return String(format: "%.2f", self)
    }
    
    // 소숫점 1자리
    var toCelsius: String {
        return String(format: "%.1f°C", self)
    }
    
    func toDecimal(num: Int) -> String {
        return String(format:"%.\(num)f", self)
    }
}

extension Int {
    var array: [Int] {
        return String(self).flatMap{ Int(String($0)) }
    }
    
    public func decimal() -> String {
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = NumberFormatter.Style.decimal
        return numberFormatter.string(from: NSNumber(value: self))!
    }
    
    public func currencyKRW() -> String {
        return "￦ " + decimal()
    }
}

extension FloatingPoint {
    
    public var degreesToRadians: Self { return self * .pi / 180 }
    public var radiansToDegrees: Self { return self * 180 / .pi }
    
}
