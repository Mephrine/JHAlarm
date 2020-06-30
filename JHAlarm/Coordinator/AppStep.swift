//
//  AppStep.swift
//  JHAlarm
//
//  Created by Mephrine on 13/11/2019.
//  Copyright © 2019 김제현. All rights reserved.
//

import RxFlow
import RxSwift

enum AppStep: Step {
    // start
//    case initIntro
    // 처음 메인 진입
    case goMain
    // 알람 상세 눌렀을 때,
    case selectAlarmEdit(data: AlarmModel)
    // 새로운 알람 생성 눌렀을 때,
    case clickNewAlarm(task: PublishSubject<Bool>)
    // 알람 닫기.
    case closeAlarmDetail
    
    
    //알람 스텝
    //Mission
    case selectChoiceAlarmMission(selected: MissionModel, task: PublishSubject<MissionModel>)
//    case selectAlarmMission(viewModel: Mission)
    case closeAlarmMission
    
    case selectAlarmMissionArithmetic(task: PublishSubject<MissionModel?>)
    
    case selectAlarmMissionShake(task: PublishSubject<MissionModel?>)
    
    case setUpAlarmMissionArithmetic
    
    case setUpAlarmMissionShake
    
    case backAlarmMissionArithmetic
    
    case backAlarmMissionShake
    
    
    //Sound
    case selectChoiceAlarmSound(initSound: AlarmSound, task: PublishSubject<AlarmSound>)
//    case selectAlarmSound(selected: AlarmSound)
    case closeAlarmSound
    
    case showAlarmMission(alarmId: String, task: PublishSubject<MissionModel?>)
    case completeAlarmMission
}
