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
    @objc dynamic var alarmID = UUID().uuidString
    // HH:mm
    @objc dynamic var date: Date = Date()
    // 미션 2개. base -> 없음
    
    var mission: MissionModel? = nil
//    var missionModel {
//        get {
//            return MissionModel.
//        }
//        set {
//            mission = newValue.rawValue
//        }
//    }
    //MissionModel.init(type: .Base, level: 0, numberOfTimes: 0)

    // 반복 일수. 선택된 요일들 저장. - List는 append delete로 사용해햐는듯..
    let repetition = List<Int>()
    // 사운드
    @objc private dynamic var soundNm = AlarmSound.RawValue()
    var soundName: AlarmSound {
        get {
            return AlarmSound(rawValue: soundNm)!
        }
        set {
            soundNm = newValue.rawValue
        }
    }
    
    // 진동 사용 여부
    @objc dynamic var useVibration: Bool = false
    // 사운드 크기 0 - 100
    @objc dynamic var soundVolume: Float = 50
    // 0 -> 60. 분으로 계산
    @objc dynamic var snoozeTime: Int = 0
    // description
    @objc dynamic var desc: String = ""
    // Enable
    @objc dynamic var used: Bool = true
    
    // snooze 관리
    @objc dynamic var onSnooze: Bool = false
    
    override static func primaryKey() -> String? {
        return "alarmID"
    }
    
    
    convenience init(date: Date) {
        self.init()
        self.date = date
    }
    
    convenience init(date: Date, mission: MissionModel, soundName: AlarmSound, useVibration: Bool, soundVolume: Float, snoozeTime: Int, desc: String, used: Bool, onSnooze: Bool) {
        self.init()
        self.date = date
        self.mission = mission
        self.useVibration = useVibration
        self.soundName = soundName
        self.soundVolume = soundVolume
        self.snoozeTime = snoozeTime
        self.desc = desc
        self.used = used
        self.onSnooze = onSnooze
    }
}


class MissionModel: Object {
//    @objc private dynamic var wakeMission = Mission.Base.hashValue
//    var missionType = Mission.RawValue()
    var wakeMission: Mission = .Base
    var level: Int = 0
    var numberOfTimes: Int = 0
    
    convenience init(wakeMission: Mission,  level: Int, numberOfTimes: Int) {
        self.init()
        self.wakeMission = wakeMission
        self.level = level
        self.numberOfTimes = numberOfTimes
    }
}


//class MissionModel: Object {
//    @objc private dynamic var missionType = Mission.RawValue()
//
//    var wakeMission: Mission {
//        get {
//            return Mission(rawValue: missionType)!
//        }
//        set {
//            missionType = newValue.rawValue
//        }
//    }
//
//    @objc var level: Int = 0
//    @objc var numberOfTimes: Int = 0
//
//    convenience init(wakeMission: Mission,  level: Int, numberOfTimes: Int) {
//        self.init()
//        self.wakeMission = wakeMission
//        self.level = level
//        self.numberOfTimes = numberOfTimes
//    }
//}
