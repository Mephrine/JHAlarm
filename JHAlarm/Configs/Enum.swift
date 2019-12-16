//
//  Enum.swift
//  JHAlarm
//
//  Created by 김제현 on 12/08/2019.
//  Copyright © 2019 김제현. All rights reserved.
//

import UIKit

enum JPEGQuality: CGFloat {
    case lowest  = 0
    case low     = 0.25
    case medium  = 0.5
    case high    = 0.75
    case highest = 1
}

enum MenuConfig: Int {
    case Alarm = 0
    case StopWatch
    case Timer
    case Watch
    case Setting
}

enum Mission: Int, CaseIterable {
    case Base = 0
    case Shake
    case Arithmetic
    
    func getName() -> String {
        switch self {
        case .Base:
            return "기본"
        case .Shake:
            return "흔들기"
        case .Arithmetic:
            return "사칙연산"
        }
    }
    
    func getImgName() -> String {
        switch self {
        case .Base:
            return "menu_alarm"
        case .Shake:
            return "mission_shake"
        case .Arithmetic:
            return "mission_arithmetic"
        }
        
    }
}

enum AlarmCategory: String, CaseIterable {
    case Base = "Base"
    case loud = "loud"
    case pop = "pop"
    case Others = "Others"
    
    func getName() -> String {
        switch self {
        case .Base:
            return "기본 알람음"
        case .loud:
            return "시끄러운 알람음"
        case .pop:
            return "사이렌 알람음"
        case .Others:
            return "기타"
        }
    }
}

enum AlarmSound: Int, CaseIterable {
    case Base0 = 0
    case Base1 = 1
    case loud0 = 10
    case loud1 = 11
    case pop0 = 100
    case pop1 = 101
    case None = -9
    
    func getFileName() -> String {
        switch self {
        case .Base0:
            return "Base0"
        case .Base1:
            return "Base1"
        case .loud0:
            return "loud0"
        case .loud1:
            return "loud1"
        case .pop0:
            return "pop0"
        case .pop1:
            return "pop1"
        case .None:
            return "Others0"
        }
    }
    
    func getName() -> String {
        switch self {
        case .Base0:
            return "기본음"
        case .Base1:
            return "기본음1"
        case .loud0:
            return "시끄러운음"
        case .loud1:
            return "시끄러운음1"
        case .pop0:
            return "사이렌"
        case .pop1:
            return "사이렌1"
        case .None:
            return "없음"
        }
    }
}

enum Weekend: Int {
    case Sun = 1
    case Mon
    case Tue
    case Wed
    case Thu
    case Fri
    case Sat
    
    func shortDateStr() -> String {
        switch self {
        case .Sun:
            return "일"
        case .Mon:
            return "월"
        case .Tue:
            return "화"
        case .Wed:
            return "수"
        case .Thu:
            return "목"
        case .Fri:
            return "금"
        case .Sat:
            return "토"
        }
    }
    
    func longDateStr() -> String {
        switch self {
        case .Sun:
            return "일요일"
        case .Mon:
            return "월요일"
        case .Tue:
            return "화요일"
        case .Wed:
            return "수요일"
        case .Thu:
            return "목요일"
        case .Fri:
            return "금요일"
        case .Sat:
            return "토요일"
        }
    }
}

enum Tense: Int {
    case past = 0
    case present
    case future
}

enum RepeatDate: String {
    case all = "매일"
    case weekdays = "주중"
    case weekend = "주말"
    case none = "선택"
}

enum FontName: String {
    case bold = "AppleSDGothicNeo-Bold"
    case ultraLight = "AppleSDGothicNeo-UltraLight"
    case thin = "AppleSDGothicNeo-Thin"
    case regular = "AppleSDGothicNeo-Regular"
    case light = "AppleSDGothicNeo-Light"
    case medium = "AppleSDGothicNeo-Medium"
    case semiBold = "AppleSDGothicNeo-SemiBold"
}
