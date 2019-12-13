//
//  AlarmModel.swift
//  JHAlarm
//
//  Created by 김제현 on 02/09/2019.
//  Copyright © 2019 김제현. All rights reserved.
//

import Foundation
import RealmSwift

class AlarmModel: Object {
    // HH:mm
    @objc dynamic var date: Date = Date()
    // 미션 2개. base -> 없음
    @objc private dynamic var wakeMission = Mission.Base.hashValue
    var mission: Mission {
        get {
            return Mission(rawValue: wakeMission)!
        }
        set {
            wakeMission = newValue.rawValue
        }
    }
    // 반복 일수. 선택된 요일들 저장.
    @objc dynamic var repetition: [Int] = []
    // 사운드
    @objc private dynamic var soundNm = AlarmSound.Base.hashValue
    var soundName: AlarmSound {
        get {
            return AlarmSound(rawValue: soundNm)!
        }
        set {
            soundNm = newValue.rawValue
        }
    }
    // 0 -> 10
    @objc dynamic var intensity: Int = 10
    // 0 -> 60. 분으로 계산
    @objc dynamic var resoundTime: Int = 0
    // description
    @objc dynamic var desc: String = ""
    // Enable
    @objc dynamic var isShowing: Bool = false
    
    convenience init(date: Date) {
        self.init()
        self.date = date
    }
    
    convenience init(date: Date, mission: Mission, repetition: [Int], soundName: AlarmSound, intensity: Int, resoundTime: Int, desc: String, isShowing: Bool) {
        self.init()
        self.date = date
        self.mission = mission
        self.repetition = repetition
        self.soundName = soundName
        self.intensity = intensity
        self.resoundTime = resoundTime
        self.desc = desc
        self.isShowing = isShowing
    }
}
