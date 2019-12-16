//
//  DateExtension.swift
//  Mwave
//
//  Created by 김제현 on 2017. 10. 6..
//  Copyright © 2017년 김제현. All rights reserved.
//

import Foundation

let YYYY_MM_DD_HH_MM_SS_zzzz = "yyyy-MM-dd HH:mm:ss +zzzz"
let YYYY_MM_DD_HH_MM_SS = "yyyy-MM-dd HH:mm:ss"
let DD_MM_YYYY = "dd-MM-yyyy"
let MM_DD_YYYY = "MM-dd-yyyy"
let YYYY_DD_MM = "yyyy-dd-MM"
let YYYY_MM_DD_T_HH_MM_SS = "yyyy-MM-dd'T'HH:mm:ss"

extension Date{
    var calendar: Calendar {
        var calendar = Calendar.current
//        calendar.timeZone = TimeZone.autoupdatingCurrent
        calendar.timeZone = TimeZone(identifier: "UTC")!
        return calendar
    }
    
    //180212 jhkim.
    func getNextMonth() -> Date? {
        return self.calendar.date(byAdding: .month, value: 1, to: self)
    }
        
    func getPreviousMonth() -> Date? {
        self.calendar.date(byAdding: .month, value: -1, to: self)
    }
    
    //180212 jhkim.
    func getNextWeek() -> Date? {
        return self.calendar.date(byAdding: .weekOfYear, value: 1, to: self)
    }
    
    func getPreviousWeek() -> Date? {
        return self.calendar.date(byAdding: .weekOfYear, value: -1, to: self)
    }
    
    
    public func ago() -> String {
        let seconds = self.correctSecondComponent().timeIntervalSince1970
        let now = Date().correctSecondComponent().timeIntervalSince1970
        let age = Int(now - seconds + 1)
        if age <= 60 { return "1분 전" }
        if age <= 60 * 60 { return "\(age / 60)분 전" }
        if age <= 60 * 60 * 24 { return "\(age / 60 / 60)시간 전" }
        if age <= 60 * 60 * 24 * 30 { return "\(age / 60 / 60 / 24)일 전" }
        if age <= 60 * 60 * 24 * 30 * 12 { return "\(age / 60 / 60 / 24 / 30)달 전" }
        return "\(age / 60 / 60 / 24 / 30 / 12)년 전"
    }
    
    public func later() -> String {
        let seconds = self.correctSecondComponent().timeIntervalSince1970
        let now = Date().correctSecondComponent().timeIntervalSince1970
        
        let age = Int(seconds - now + 1)
        if age <= 60 { return "1분 이내로 울림" }
        if age <= 60 * 60 { return "\(age / 60)분 후에 울림" }
        if age <= 60 * 60 * 24 { return #"\#(age / 60 / 60)시간 \#((age / 60) % 60)분 후에 울림"# }
        if age <= 60 * 60 * 24 * 30 { return "\(age / 60 / 60 / 24)일 후에 울림" }
        return ""
    }
    
    public func isFuture() -> Bool {
        let seconds = self.correctSecondComponent().timeIntervalSince1970
        let now = Date().correctSecondComponent().timeIntervalSince1970
        
        return seconds > now
    }
    
    public func remain() -> String {
        let seconds = self.timeIntervalSince1970
        let now = Date().timeIntervalSince1970
        var remains = Int(seconds - now)
        if remains <= 0 { return "" }
        
        var dayString = ""
        
        let sec = remains % 60
        remains /= 60
        
        let minutes = remains % 60
        remains /= 60
        
        let hour = remains % 24
        remains /= 24
        
        let days = remains
        
        if days == 1 {
            dayString = "1Day"
        } else if days > 1 {
            dayString = "\(days)Days"
        }
        
        return String(format: "%@ %02d:%02d:%02d", dayString, hour, minutes, sec)
    }
    
    public func remainKr() -> String {
        let seconds = self.timeIntervalSince1970
        let now = Date().timeIntervalSince1970
        var remains = Int(seconds - now)
        if remains <= 0 { return "" }
        
        let sec = remains % 60
        remains /= 60
        
        let minutes = remains % 60
        remains /= 60
        
        let hour = remains % 24
        remains /= 24
        
        let days = remains
        
        return String(format: "%d일 %02d시간 %02d분 %02d초", days, hour, minutes, sec)
    }
    
    public static func fromFormat(_ format: String) -> (String) -> Date? {
        let df = DateFormatter()
        df.dateFormat = format
        df.timeZone = TimeZone.init(abbreviation: "UTC")
        return { dateString in
            guard !dateString.isEmpty else { return nil }
            return df.date(from: dateString)
        }
    }
    //Convert Date to String
       func convertDateToString(strDateFormate:String) -> String{
           let dateFormatter = DateFormatter()
           dateFormatter.dateFormat = strDateFormate
           let strDate = dateFormatter.string(from: self)
           //      dateFormatter = nil
           return strDate
       }
    
    
    public static func fromServerFormat() -> (String) -> Date? {
        return fromFormat("yyyy-MM-dd HH:mm:ss")
    }
    
    public func formatted(_ format: String) -> String {
        let df = DateFormatter()
        df.dateFormat = format
//        df.locale = Locale.autoupdatingCurrent
        df.timeZone = TimeZone(identifier: "UTC")!
        
//        df.locale = Locale(identifier: "en_US_POSIX")
//        df.timeZone = TimeZone.init(secondsFromGMT: 60*60*9)
        return df.string(from: self)
    }
    
    public func dateToString(date: Date, _ format: String = "yyyy-MM-dd") -> String {
        let df = DateFormatter()
        df.dateFormat = format
//        df.timeZone = TimeZone(identifier: "UTC")!
        df.timeZone = TimeZone.autoupdatingCurrent
//        dateFormatter.timeZone = TimeZone(abbreviation: "GMT+0:00")
        
        //        df.locale = Locale(identifier: "en_US_POSIX")
//        df.timeZone = TimeZone.init(secondsFromGMT: 60*60*9)
        return df.string(from: date)
    }
    
    public func serverFormat() -> String {
        return self.formatted("yyyy-MM-dd HH:mm:ss")
    }
    
    public func shortDate() -> String {
        return self.formatted("yyyyMMdd")
    }
    
    public func longDate() -> String {
        return self.formatted("yyyy년 MM월 dd일")
    }
    
    public func timestamp() -> String {
        return self.formatted("yyyy/MM/dd HH:mm")
    }
    
    public func timestampDetail() -> String {
        return self.formatted("yyyy-MM-dd HH:mm:ss")
    }
    
    public static func currentTimeInMilli() -> Int {
        return Date().timeInMilli()
    }
    
    public func timeInMilli() -> Int {
        return Int(self.timeIntervalSince1970 / 1000.0)
    }
    
    init(milli: UInt64) {
        self.init(timeIntervalSince1970: (TimeInterval(milli) / 1000.0))
    }
    
    // 두 날짜간 비교해서 과거/현재/미래 체크.
    public func dateCompare(fromDate:Date) -> String {
        var strDateMessage:String = ""
        let result:ComparisonResult = self.compare(fromDate)
        switch result {
        case .orderedAscending:
            strDateMessage = "Future"
            break
        case .orderedDescending:
            strDateMessage = "Past"
            break
        case .orderedSame:
            strDateMessage = "Same"
            break
        default:
            strDateMessage = "Error"
            break
        }
        return strDateMessage
    }
    
    // 3개의 날짜 비교. 내가 원하는 시간이 해당 기간에 포함되는지!
    // 1 : 기간에 포함됨
    // 2 : 기간에 포함안됨 - 날짜가 지났음
    // 3 : 기간에 포함안됨 - 날짜가 시작되지 않음
    //
    public func dateCompare(startDate: Date, endDate: Date) -> Int {
        let compare = dateCompare(fromDate: startDate)
        let compare2 = dateCompare(fromDate: endDate)
        
        if compare == "Past" {
            if compare2 == "Future" {
                // 두 날짜 사이에 포함.
                return 1
            }
            else{
                // endDate을 벗어남.
                return 2
            }
        }
            
        else if compare == "Same" {
            //  현재
            return 1
        } else {
            // startDate 이전.
            return 3
        }
    }

    func calCalendar(byAdding: Calendar.Component, value: Int) -> Date {
        return self.calendar.date(byAdding: byAdding, value: value, to: self) ?? self
    }
    
    var dateSymbol: String {
        return self.dateToString(date: self, "a")
    }
    
    var time: String {
        return self.dateToString(date: self, "HH:mm")
    }
    
    // 1이 일요일. 6이 토요일.
    func getDayOfTheWeek() -> Int {
        return self.calendar.component(.weekday, from: self)
    }
    
    // GMT 자동으로 변환해서 보여줌.
    func toString( dateFormat format: String ) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        dateFormatter.timeZone = TimeZone(identifier: "UTC")!
        return dateFormatter.string(from: self)
    }
    
    // GMT + 9
//    func toStringKST( dateFormat format: String ) -> String {
//        return self.toString(dateFormat: format)
//    }
    
    // GMT 0
    func toStringUTC( dateFormat format: String ) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        dateFormatter.timeZone = TimeZone(abbreviation: "UTC")
        return dateFormatter.string(from: self)
    }
    
    
     /// 요일 반환
        func getWeekDayStr() -> String {
            
            let units: Set<Calendar.Component> = [.weekday]
            var comps = self.calendar.dateComponents(units, from: self)
            
            if let value = comps.weekday {
                switch value {
                case 1:
                    return "일"
                case 2:
                    return "월"
                case 3:
                    return "화"
                case 4:
                    return "수"
                case 5:
                    return "목"
                case 6:
                    return "금"
                case 7:
                    return "토"
                default:
                    return "일"
                }
            }
            return "일"
        }
        
        /// 스트링 변환 : 날짜 포멧
        func toString(format:String, am:String? = nil, pm:String? = nil)-> String {
            let dateFormatter = DateFormatter()
            dateFormatter.timeZone = TimeZone(abbreviation: "GMT+0:00")
            dateFormatter.dateFormat = format
            
            if let amSymbol = am {
                dateFormatter.amSymbol = amSymbol
            }
            if let pmSymbol = pm {
                dateFormatter.pmSymbol = pmSymbol
            }
                
            return dateFormatter.string(from: self)
        }
        
        // 날짜 변환 : 날짜 포멧
        func toDateKoreaTime()-> Date {
            
            var today = Date()
            let format = "yyyyMMddHHmmss"
            let date = self.toString(format:format)
            let formatter = DateFormatter()
            formatter.dateFormat = format
            formatter.timeZone = TimeZone(secondsFromGMT: -9 * 60 * 60)
            if let value = formatter.date(from:date) {
                today = value
            }
            
            return today
        }
        
        ////////////// Day 계산 //////////////
        // 이전 일
        func prevDay() -> Date {
            return nextDay(-1)
        }
        // 이전 일
        func prevDay(_ num:Int) -> Date {
            return nextDay(-num)
        }
        // 다음 일
        func nextDay() -> Date {
            return nextDay(1)
        }
        // 다음 일
        func nextDay(_ num:Int) -> Date {
            let units: Set<Calendar.Component> = [.day, .month, .year]
            var comps = self.calendar.dateComponents(units, from: self)
            comps.day = comps.day!+num
            
            return self.calendar.date(from: comps)!
        }
        // 다음 일
        func newRemoveTime() -> Date {
            let units: Set<Calendar.Component> = [.day, .month, .year]
            var comps = self.calendar.dateComponents(units, from: self)

            return self.calendar.date(from: comps)!
        }
        
        // 특정 '분' 추가
        func adding(minutes: Int) -> Date {
            return Calendar.current.date(byAdding: .minute, value: minutes, to: self)!
        }
        
    func getWeekDay() -> Int {
        let units: Set<Calendar.Component> = [.weekday]
        let comps = self.calendar.dateComponents(units, from: self)
        return (comps.weekday ?? 0)
    }
        
        func isSunday() -> Bool {
            let units: Set<Calendar.Component> = [.weekday]
            var comps = self.calendar.dateComponents(units, from: self)
            
            return ((comps.weekday ?? 0) - 1) == 0
        }
        
        func isSaturday() -> Bool {
            let units: Set<Calendar.Component> = [.weekday]
            var comps = self.calendar.dateComponents(units, from: self)
            
            return ((comps.weekday ?? 0) - 7) == 0
        }
        
        func removeTime() -> Date {
            let components = self.calendar.dateComponents([.year, .month, .day], from: self)
            return Calendar.current.date(from: components)!
        }
        
        func getHour() -> Int {
            let hour = self.calendar.component(.hour, from: self)
            return hour
        }
        func getMinute() -> Int {
            let minute = self.calendar.component(.minute, from: self)
            return minute
        }
        
    //    static func dates(from fromDate: Date, to toDate: Date) -> [Date] {
    //        var dates: [Date] = []
    //        var date = fromDate
    //
    //        while date <= toDate {
    //            dates.append(date)
    //            guard let newDate = Calendar.current.date(byAdding: .day, value: 1, to: date) else { break }
    //            date = newDate
    //        }
    //        return dates
    //    }
    //
        static func daysBetweenDates(startDate: Date, endDate: Date) -> Int
        {
            let calendar = Calendar.current

            // Replace the hour (time) of both dates with 00:00
            let date1 = calendar.startOfDay(for: startDate)
            let date2 = calendar.startOfDay(for: endDate)

            let components = calendar.dateComponents([.day], from: date1, to: date2)

            return components.day ?? 0
        }
        
        static func daysBetweenDatesMinute(startDate: Date, endDate: Date) -> Int
        {
            let calendar = Calendar.current
            let components = calendar.dateComponents([.minute], from: startDate, to: endDate)

            return components.minute ?? 0
        }
    
    
    func correctSecondComponent(calendar: Calendar = Calendar(identifier: Calendar.Identifier.gregorian))->Date {
        let second = calendar.component(.second, from: self)
        let d = (calendar as NSCalendar).date(byAdding: NSCalendar.Unit.second, value: -second, to: self, options:.matchStrictly)!
        return d
    }
    
    func correctSecondComponent()->Date {
        let second = self.calendar.component(.second, from: self)
        let d = (self.calendar as NSCalendar).date(byAdding: NSCalendar.Unit.second, value: -second, to: self, options:.matchStrictly)!
        return d
    }
    
}
