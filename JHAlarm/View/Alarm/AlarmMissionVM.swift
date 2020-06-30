//
//  AlarmMissionVM.swift
//  JHAlarm
//
//  Created by Mephrine on 16/10/2019.
//  Copyright © 2019 김제현. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa
import RxFlow

class AlarmMissionVM: BaseVM {
    var disposeBag = DisposeBag()
    
    // Send Detail to List
    let task: PublishSubject<MissionModel>?
    
    // input
    var initItem: MissionModel
    var selectedItem = BehaviorSubject<MissionModel>(value: .init(wakeMission: .Base, level: 0, numberOfTimes: 0))
        
    // output
    var missionList: Observable<[AlarmMissionModel]> {
        var missionItmes = [MissionModel]()
        for mission in Mission.allCases {
            if mission == initItem.wakeMission {
                missionItmes.append(initItem)
            } else {
                missionItmes.append(MissionModel.init(wakeMission: mission, level: 0, numberOfTimes: 0))
            }
        }
        let item = AlarmMissionModel(header: "", items: missionItmes)
        return Observable.just([item])
    }
    
    init(selected: MissionModel, task: PublishSubject<MissionModel>) {
        self.initItem = selected
        self.task = task
        self.selectedItem.onNext(selected)
    }
    
    func setSelected(index: Int) {
        if let selected = Mission(rawValue: index) {
            let model = MissionModel.init(wakeMission: selected, level: 0, numberOfTimes: 0)
            self.selectedItem.onNext(model)
        }
    }
    
    func getSelectedItem() -> MissionModel {
        do {
            return try selectedItem.value()
        } catch {}
        
        return MissionModel.init(wakeMission: Mission.Base, level: 0, numberOfTimes: 0)
    }
    
    func isSelected(row: Int) -> Bool {
        log.d("selected : \(self.getSelectedItem().wakeMission.rawValue) | \(row)")
        return self.getSelectedItem().wakeMission.rawValue == row
    }
    
    // MARK: Move
    @objc func dismiss() {
        self.steps.accept(AppStep.closeAlarmMission)
    }
    
    func saveMission(model: MissionModel) {
        self.task?.onNext(model)
        self.steps.accept(AppStep.closeAlarmMission)
    }
    
    func move(_ selectedMission: MissionModel) {
        let mission = selectedMission.wakeMission
        switch mission {
        case .Arithmetic:
            let task = PublishSubject<MissionModel?>()
            task.subscribe(onNext: { [weak self] in
                guard let _self = self else { return }
                if let model = $0 {
                    _self.saveMission(model: model)
                } else {
                    _self.selectedItem.onNext(_self.initItem)
                }
                }).disposed(by: disposeBag)
            self.steps.accept(AppStep.selectAlarmMissionArithmetic(task: task))
            break
        case .Shake:
            let task = PublishSubject<MissionModel?>()
            task.subscribe(onNext: { [weak self] in
                guard let _self = self else { return }
                if let model = $0 {
                    _self.saveMission(model: model)
                } else {
                    _self.selectedItem.onNext(_self.initItem)
                }
                }).disposed(by: disposeBag)
            self.steps.accept(AppStep.selectAlarmMissionShake(task: task))
            break
        case .Base:
            let model = MissionModel.init(wakeMission: .Base, level: 0, numberOfTimes: 0)
            self.saveMission(model: model)
            break
        }
    }
}

