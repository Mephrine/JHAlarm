//
//  AlarmMissionPlayVM.swift
//  JHAlarm
//
//  Created by 김제현 on 2019/12/13.
//  Copyright © 2019 김제현. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa
import RxFlow
import SwiftyUserDefaults

class AlarmMissionPlayVM: BaseVM {
    var disposeBag = DisposeBag()
    
    // Send Detail to List
    let task: PublishSubject<MissionModel?>?
    
    
    let num1 = BehaviorRelay<Int>(value: 0)
    let num2 = BehaviorRelay<Int>(value: 0)
    let isPlusSymbol = BehaviorRelay<Bool>(value: true)
    
    var correct: Int = 0
    
    let alarmID: String
    
    
    init(alarmID: String, task: PublishSubject<MissionModel?>? = nil) {
        self.alarmID = alarmID
        self.task = task
    }
    
    // MARK: Move
    func dismiss() {
//        self.task.onNext()
        self.steps.accept(AppStep.completeAlarmMission)
    }
    
    func setMission() {
        var rnd1 = Int.random(in: 1..<100)
        var rnd2 = Int.random(in: 1..<100)
        let rndSymbol = Bool.random()
        
        if !rndSymbol && rnd1 < rnd2 {
            let a = rnd1
            rnd1 = rnd2
            rnd2 = a
        }
        
        if rndSymbol {
            correct = rnd1 + rnd2
        } else {
            correct = rnd1 - rnd2
        }
        
        num1.accept(rnd1)
        num2.accept(rnd2)
        isPlusSymbol.accept(Bool.random())
    }
    
    func chkQuizAnswer(answer: String) -> Bool {
        if let appDelegate = UIApplication.shared.delegate as? AppDelegate {
            appDelegate.stopAlarm()
        }
        Defaults[.UD_PLAY_MISSION] = nil
        
        return String(correct) == answer
    }
}


