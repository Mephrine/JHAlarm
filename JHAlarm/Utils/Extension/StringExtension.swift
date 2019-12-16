//
//  StringExtension.swift
//  Mwave
//
//  Created by 김제현 on 2017. 8. 11..
//  Copyright © 2017년 김제현. All rights reserved.
//

import Foundation
import Localize_Swift
import SwiftyUserDefaults

extension String {
    
    var length : Int {
        return self.count
    }
    
    var URLEscapedString: String {
        return self.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlHostAllowed)!
    }
    
    
    var localized: String {
        return NSLocalizedString(self, tableName: nil, bundle: Bundle.main, value: "", comment: "")
    }
    
    func local() ->String {
        let path = Bundle.main.path(forResource: Localize.currentLanguage(), ofType: "lproj")
        let bundle = Bundle(path: path!)
        
        return NSLocalizedString(self, tableName: nil, bundle: bundle!, value: "", comment: "")
        //        return NSLocalizedString(self, tableName: nil, bundle: Bundle.main, value: "", comment: "")
    }
    
    
    func local(_ lang:String) ->String {
        
        let path = Bundle.main.path(forResource: lang, ofType: "lproj")
        let bundle = Bundle(path: path!)
        
        return NSLocalizedString(self, tableName: nil, bundle: bundle!, value: "", comment: "")
    }
    
    func encodeUrl() -> String
    {
        return self.addingPercentEncoding( withAllowedCharacters: NSCharacterSet.urlQueryAllowed)!
    }
    
    func decodeUrl() -> String
    {
        return self.removingPercentEncoding!
    }
    
    func url() -> URL {
        let urlText = trim()
        if let url = URL(string: urlText) {
            return url
        }
        if let urlString = urlText.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed),
            let url = URL(string: urlString) {
            return url
        }
        return NSURLComponents().url! // empty url
    }
    
    
    func replace(target: String, withString: String) -> String {
        return self.replacingOccurrences(of: target, with: withString)
    }
    
    
    //    subscript(r: Range<Int>) -> String {
    //        get {
    //            let startIndex = self.index(self.startIndex, offsetBy: r.lowerBound)
    //            let endIndex = self.index(self.startIndex, offsetBy: r.upperBound)
    //
    //            return self[startIndex..<endIndex]
    //        }
    //    }
    //
    //    subscript(r: ClosedRange<Int>) -> String {
    //        get {
    //            let startIndex = self.index(self.startIndex, offsetBy: r.lowerBound)
    //            let endIndex = self.index(self.startIndex, offsetBy: r.upperBound)
    //
    //            return self[startIndex...endIndex]
    //        }
    //    }
    
    
    
    func urlEncode() -> CFString {
        return CFURLCreateStringByAddingPercentEscapes(
            nil,
            self as CFString,
            nil,
            "!*'();:@&=+$,/?%#[]" as CFString,
            CFStringBuiltInEncodings.UTF8.rawValue
        )
    }
    
    
    
    var isNumber : Bool {
        get{
            return !self.isEmpty && self.rangeOfCharacter(from: CharacterSet.decimalDigits.inverted) == nil
        }
    }
    
    // 특문 제거.
    func removeSpecialChars() -> String {
        
        //_, 스페이스는 제거 안 됨.
        //        let regular = "[^\\w\\sㄱ-ㅎ가-힣ㅏ-ㅣ]|"
        
        //스페이스만 제거 안 됨.
        //        let regular = "[^\\w\\sㄱ-ㅎ가-힣ㅏ-ㅣ]|[_]"
        
        //스페이스, _ 모두 제거
        let regular = "[^\\wㄱ-ㅎ가-힣ㅏ-ㅣ]|[_]"
        return self.replacingOccurrences(of: regular, with: "", options: .regularExpression)
    }
    
    
    //180104 jhkim.
    func fromBase64() -> String? {
        // = 이거때문에 디코딩 에러남... 처리해줘야해서 추가!
        let encoded64 = self.padding(toLength: ((self.count+3)/4)*4,
                                     withPad: "=",
                                     startingAt: 0)
        
        guard let data = Data(base64Encoded: encoded64) else {
            return nil
        }
        
        return String(data: data, encoding: .utf8)
    }
    
    func toBase64() -> String {
        return Data(self.utf8).base64EncodedString()
    }
    
    
    func utf8DecodedString()-> String {
        let data = self.data(using: .utf8)
        if let message = String(data: data!, encoding: .nonLossyASCII){
            return message
        }
        return ""
    }
    
    func utf8EncodedString()-> String {
        let messageData = self.data(using: .nonLossyASCII)
        let text = String(data: messageData!, encoding: .utf8)
        return text ?? ""
    }
    
//    func md5Encoded()-> Data {
//        let messageData = self.data(using:.utf8)!
//        var digestData = Data(count: Int(CC_MD5_DIGEST_LENGTH))
//
//        _ = digestData.withUnsafeMutableBytes {digestBytes in
//            messageData.withUnsafeBytes {messageBytes in
//                CC_MD5(messageBytes, CC_LONG(messageData.count), digestBytes)
//            }
//        }
//
//        return digestData
//    }
//
//    func md5EncodedHex()-> String {
//        let digestData = self.md5Encoded()
//        return digestData.map { String(format: "%02hhx", $0) }.joined()
//    }
//
//    func md5EncodedBase64()-> String {
//        let digestData = self.md5Encoded()
//
//        return digestData.base64EncodedString()
//    }
    
    func trimSpaceLine() -> String {
        return self.trimmingCharacters(in: .whitespacesAndNewlines)
    }
    
    func trimLine() -> String {
        return self.trimmingCharacters(in: .newlines)
    }
    
    func trimTrailingWhitespace() -> String {
        if let trailingWs = self.range(of: "\\s+$", options: .regularExpression) {
            return self.replacingCharacters(in: trailingWs, with: "")
        } else {
            return self
        }
    }
    
    func trailingTrim(_ characterSet : CharacterSet) -> String {
        if let range = rangeOfCharacter(from: characterSet, options: [.anchored, .backwards]) {
            return self.substring(to: range.lowerBound).trailingTrim(characterSet)
        }
        return self
    }
    
    func leadingTrim(_ characterSet : CharacterSet) -> String {
        if let range = rangeOfCharacter(from: characterSet, options: [.anchored]) {
            return self.substring(to: range.lowerBound).leadingTrim(characterSet)
        }
        return self
    }
    
    var youtubeID: String? {
        let pattern = "((?<=(v|V)/)|(?<=be/)|(?<=(\\?|\\&)v=)|(?<=embed/))([\\w-]++)"
        
        let regex = try? NSRegularExpression(pattern: pattern, options: .caseInsensitive)
        let range = NSRange(location: 0, length: count)
        
        guard let result = regex?.firstMatch(in: self, options: [], range: range) else {
            return nil
        }
        
        return (self as NSString).substring(with: result.range)
    }
    
    
    //검색
    func regex(regex: String) -> Bool {
        let predicate = NSPredicate(format:"SELF MATCHES %@", regex)
        return predicate.evaluate(with: description)
    }
    
    func index(from: Int) -> Index {
        return self.index(startIndex, offsetBy: from)
    }
    
    func getArrayAfterRegex(regex: String) -> [String] {
        
        do {
            let regex = try NSRegularExpression(pattern: regex)
            let results = regex.matches(in: self,
                                        range: NSRange(self.startIndex..., in: self))
            return results.map {
                String(self[Range($0.range, in: self)!])
            }
        } catch let error {
            print("invalid regex: \(error.localizedDescription)")
            return []
        }
    }
    
    //
    //    public func index(of character: Character) -> Int? {
    //        if let index = characters.index(of: character) {
    //            return characters.distance(from: startIndex, to: index)
    //        }
    //        return nil
    //    }
    
    
    func index(at offset: Int, from start: Index? = nil) -> Index? {
        return index(start ?? startIndex, offsetBy: offset, limitedBy: endIndex)
    }
    
    
    func character(at offset: Int) -> Character? {
        precondition(offset >= 0, "offset can't be negative")
        guard let index = index(at: offset) else { return nil }
        return self[index]
    }
    
    
    // MARK: - sub string
    subscript (range: Range<Int>) -> String {
        get {
            var lower = range.lowerBound
            var upper = range.upperBound
            
            guard self.count > 0 else {
                return ""
            }
            
            if lower < 0 {
                lower = 0
            }
            
            if upper >= self.count {
                upper = self.count
            }
            
            let start = self.index(self.startIndex, offsetBy: lower)
            let end = self.index(self.startIndex, offsetBy: upper)
            let value = Range<String.Index>(uncheckedBounds: (lower: start, upper: end))
            return String(self[value])
        }
    }
    
    subscript (range: ClosedRange<Int>) -> String {
        get {
            var lower = range.lowerBound
            var upper = range.upperBound
            
            guard self.count > 0 else {
                return ""
            }
            
            if lower < 0 {
                lower = 0
            }
            
            if upper >= self.count {
                upper = self.count - 1
            }
            
            let start = self.index(self.startIndex, offsetBy: lower)
            let end = self.index(self.startIndex, offsetBy: upper)
            let value = ClosedRange<String.Index>(uncheckedBounds: (lower: start, upper: end))
            return String(self[value])
        }
    }
    
    subscript (range: PartialRangeThrough<Int>) -> String {
        get {
            guard self.count > 0 else {
                return ""
            }
            
            var upper = range.upperBound
            
            if upper >= self.count {
                upper = self.count - 1
            }
            
            let end = self.index(self.startIndex, offsetBy: upper)
            let value = PartialRangeThrough<String.Index>(end)
            return String(self[value])
        }
    }
    
    subscript (range: PartialRangeUpTo<Int>) -> String {
        get {
            guard self.count > 0 else {
                return ""
            }
            
            var upper = range.upperBound
            
            if upper >= self.count {
                upper = self.count
            }
            
            let end = self.index(self.startIndex, offsetBy: upper)
            let value = PartialRangeUpTo<String.Index>(end)
            return String(self[value])
        }
    }
    
    subscript (range: PartialRangeFrom<Int>) -> String {
        get {
            guard self.count > 0 else {
                return ""
            }
            var lower = range.lowerBound
            
            if lower < 0 {
                lower = 0
            }
            
            let start = self.index(self.startIndex, offsetBy: lower)
            let value = PartialRangeFrom<String.Index>(start)
            return String(self[value])
        }
    }
    
    subscript(_ range: CountableRange<Int>) -> Substring {
        precondition(range.lowerBound >= 0, "lowerBound can't be negative")
        let start = index(at: range.lowerBound) ?? endIndex
        return self[start..<(index(at: range.count, from: start) ?? endIndex)]
    }
    subscript(_ range: CountableClosedRange<Int>) -> Substring {
        precondition(range.lowerBound >= 0, "lowerBound can't be negative")
        let start = index(at: range.lowerBound) ?? endIndex
        return self[start..<(index(at: range.count, from: start) ?? endIndex)]
    }
    subscript(_ range: PartialRangeUpTo<Int>) -> Substring {
        return prefix(range.upperBound)
    }
    subscript(_ range: PartialRangeThrough<Int>) -> Substring {
        return prefix(range.upperBound+1)
    }
    subscript(_ range: PartialRangeFrom<Int>) -> Substring {
        return suffix(max(0,count-range.lowerBound))
    }
    
    subscript (i: Int) -> Substring {
        return self[i ..< i + 1]
    }
    
    
    func size(_ font: UIFont) -> CGSize {
        #if swift(>=4)
        return NSAttributedString(string: self, attributes: [NSAttributedString.Key.font: font]).size()
        #else
            return NSAttributedString(string: self, attributes: [NSFontAttributeName: font]).size()
        #endif
    }
    
    func width(_ font: UIFont) -> CGFloat {
        return size(font).width
    }
    
    func height(_ font: UIFont) -> CGFloat {
        return size(font).height
    }
    
    func trim() -> String {
        return trimmingCharacters(in: CharacterSet.whitespaces)
    }
    
    func fittingSubstring(_ width: CGFloat, font: UIFont) -> String {
        for i in stride(from: self.count, to: 0, by: -1) {
            let index = self.index(self.startIndex, offsetBy: i)
            let substr = self[self.startIndex..<index]
            if String(substr).width(font) <= width {
                return String(substr)
            }
        }
        return ""
    }
    
    func truncate(_ width: CGFloat, font: UIFont) -> String {
        let ellipsis = "..."
        let substr = fittingSubstring(width - ellipsis.width(font), font: font)
        if substr.count != count {
            return "\(substr.trim())\(ellipsis)"
        } else {
            return self
        }
    }
    
    func toCGFloat() -> CGFloat {
        guard let n = NumberFormatter().number(from: self) else {
            return 0.0
        }
        return CGFloat(n)
    }
    
    
    var asciiArray: [UInt32] {
        return unicodeScalars.filter{$0.isASCII}.map{$0.value}
    }
    
    
    func encodeURIComponent() -> String {
        let allowedCharacterSet = (CharacterSet(charactersIn: "!*'();:@&=+$,/?%#[] ").inverted)
        
        if let escapedString = self.addingPercentEncoding(withAllowedCharacters: allowedCharacterSet) {
            //do something with escaped string
            return escapedString
        }
        
        return self
        
    }
    
    func encodeEucKr() -> String {
        //EUC-KR 인코딩
        let rawEncoding = CFStringConvertEncodingToNSStringEncoding(CFStringEncoding(CFStringEncodings.EUC_KR.rawValue))
        let encoding = String.Encoding(rawValue: rawEncoding)
        let eucKRStringData = self.data(using: encoding) ?? Data()
        let outputQuery = eucKRStringData.map {
            byte->String in
            if byte >= UInt8(ascii: "A") && byte <= UInt8(ascii: "Z") || byte >= UInt8(ascii: "a") && byte <= UInt8(ascii: "z") || byte >= UInt8(ascii: "0") && byte <= UInt8(ascii: "9") || byte == UInt8(ascii: "_") || byte == UInt8(ascii: ".") || byte == UInt8(ascii: "-") {
                return String(Character(UnicodeScalar(UInt32(byte))!))
            } else if byte == UInt8(ascii: " ") {
                return "+"
            } else {
                return String(format: "%%%02X", byte)
            }
        }.joined()
        return outputQuery
        
    }
    
    func split(_ separator: String) -> Array<String>{
        let arrayString = self.components(separatedBy: separator)
        let arrayResult = NSMutableArray()
        
        for string in arrayString {
            arrayResult.add(string)
        }
        
        return arrayResult as! Array<String>
    }
    
    // MARK: - func
    // MARK: - 자릿수
    func decimal() -> String? {
        if let number = Int(self) {
            let numberFormatter = NumberFormatter()
            numberFormatter.numberStyle = .decimal
            
            return numberFormatter.string(from: NSNumber(value:number))
        } else {
            return nil
        }
    }
    
    // MARK: - html string
    func htmlAttributedString(font: UIFont) -> NSAttributedString? {
        guard let data = self.data(using: String.Encoding.utf16, allowLossyConversion: false) else {
            return nil
        }
        
        guard let html = try? NSMutableAttributedString(
            data: data,
            options: [.documentType: NSAttributedString.DocumentType.html],
            documentAttributes: nil) else {
                return nil
        }
        
        html.addAttribute(.font, value: font, range: NSMakeRange(0, html.string.utf16.count))
        
        return html
    }
    
    // MARK: - file path
    func appendingPathComponent(path: String) -> String {
        return (self as NSString).appendingPathComponent(path)
    }
    
    func appendingPathExtension(ext: String) -> String? {
        return (self as NSString).appendingPathExtension(ext)
    }
    
    func localizedWithComment(_ comment: String) -> String
    {
        return NSLocalizedString(self, comment:comment)
    }
    
    func localizedWithLang(_ lang: String) -> String
    {
        let path = Bundle.main.path(forResource: lang, ofType: "lproj")
        let bundle = Bundle(path: path!)
        return NSLocalizedString(self, bundle:bundle!, comment: "")
    }
    
    // MARK: - string size
    func sizeWithFont(_ font: UIFont, forWidth width: CGFloat) -> CGSize {
        return self.sizeWithFont(font, forWidth: width, line: .byWordWrapping)
    }
    
    func sizeWithFont(_ font: UIFont, forWidth width: CGFloat, line: NSLineBreakMode) -> CGSize {
        let fString = self as NSString
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineBreakMode = line
        let attrDict = [
            NSAttributedString.Key.font: font,
            NSAttributedString.Key.paragraphStyle: paragraphStyle
        ]
        let maximumSize = CGSize(width: width, height: CGFloat(MAXFLOAT))
        let rect = fString.boundingRect(with: maximumSize,
                                        options: [.truncatesLastVisibleLine, .usesLineFragmentOrigin],
                                        attributes: attrDict,
                                        context: nil)
        return rect.size
    }
    
    public static var uuid: String {
        return UUID().uuidString
    }
    
}

extension Character {
    var asciiValue: UInt32? {
        return String(self).unicodeScalars.filter{$0.isASCII}.first?.value
    }
    
    //    func isEmoji() -> Bool {
    //        return Character(UnicodeScalar(0x1d000)) <= self && self <= Character(UnicodeScalar(0x1f77f))
    //            || Character(UnicodeScalar(0x1f900)) <= self && self <= Character(UnicodeScalar(0x1f9ff))
    //            || Character(UnicodeScalar(0x2100)) <= self && self <= Character(UnicodeScalar(0x26ff))
    //    }
}

//StringExtension.swift
protocol StringOptionalProtocol {}
extension String: StringOptionalProtocol {}

extension Optional where Wrapped: StringOptionalProtocol {
    // nil 또는 빈값의 경우 true 리턴
    var isEmpty: Bool {
        if let str = self as? String {
            return str.isEmpty //랩핌을 했기 때문에 빈값으로 처리
        }
        return true // 랩핑을 실패하면 nil로 처리
    }
    
    // nil 또는 빈값의 경우 false리턴
    var isNotEmpty: Bool {
        guard let str = self as? String else {
            return false // 랩핑에 실패하였기 때문에 nil 처리
        }
        return !str.isEmpty // 랩핑에 성공했기 때문에 빈값이 아닌지 체크
    }
}

extension Substring {
    var string: String { return String(self) }
}
