//
//  AlarmMissionArithmeticVM.swift
//  JHAlarm
//
//  Created by Mephrine on 21/11/2019.
//  Copyright © 2019 김제현. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa
import RxFlow

class AlarmMissionArithmeticVM: BaseVM {
    var disposeBag = DisposeBag()
    
    // Send Detail to List
    let task = PublishSubject<MissionModel?>()
    
    
    
    // MARK: Move
    @objc func popViewController() {
        self.task.onNext(nil)
        self.steps.accept(AppStep.backAlarmMissionArithmetic)
    }

    func setMissionAndDismiss() {
        let model = MissionModel.init(wakeMission: .Arithmetic, level: 0, numberOfTimes: 0)
        self.task.onNext(model)
        self.steps.accept(AppStep.setUpAlarmMissionArithmetic)
    }
}
