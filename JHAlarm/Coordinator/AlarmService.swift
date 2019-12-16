//
//  AlarmService.swift
//  JHAlarm
//
//  Created by Mephrine on 13/11/2019.
//  Copyright © 2019 김제현. All rights reserved.
//

import Foundation

protocol HasAlarmService {
    var alarmService: AlarmService { get }
}

// Flow에서 다른 ViewController로 값을 전달하고, 해당 값을 Service에서 가공해서 ViewModel에서 사용할 수 있도록 하는 함수들.
class AlarmService {
    // 전달할 데이터
    private var mission: Mission?
    private var alarmSound: AlarmSound?
    
    init(selectedMission: Mission) {
        self.mission = selectedMission
        self.alarmSound = nil
    }
    
    init(selectedSound: AlarmSound) {
        self.mission = nil
        self.alarmSound = selectedSound
    }
    
    func getMission() -> Mission {
        return mission ?? .Base
    }
    
    func getAlarmSound() -> AlarmSound {
        return alarmSound ?? .Base0
    }
    
}
