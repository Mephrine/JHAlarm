//
//  AlarmDetailVM.swift
//  JHAlarm
//
//  Created by 김제현 on 02/09/2019.
//  Copyright © 2019 김제현. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa
import RealmSwift
import RxRealm
import RxFlow


class AlarmDetailVM: BaseVM {
    //Realm
    var schedule: AlarmModel?
    
    // Send Detail to List
    let task = PublishSubject<Bool>()
    
    let alarmDt = BehaviorRelay<Date>(value: Date())
    
    let mission = BehaviorRelay<MissionModel>(value: MissionModel.init(wakeMission: .Base, level: 0, numberOfTimes: 0))
    
    var repeatDay = BehaviorRelay<[Weekend]>(value: [])
    
    var soundNm = BehaviorRelay<AlarmSound>(value: .Base0)
    var switchVibrate = BehaviorRelay<Bool>(value: false)
    var soundVolume = BehaviorRelay<Float>(value: 50)
    
    var snoozeTime = BehaviorRelay<Int>(value: 0)
    var alarmDesc = BehaviorRelay<String>(value: "")
    
    var disposeBag = DisposeBag()
    
    var isEditing = false
    
    init(schedule: AlarmModel?) {
        if let data = schedule {
            self.isEditing = true
            self.schedule = data
            
            // 반복 날짜 데이터.
            let repeationArray = Array(data.repetition)
            
            self.mission.accept(data.mission ?? MissionModel.init(wakeMission: .Base, level: 0, numberOfTimes: 0))
            self.repeatDay.accept(repeationArray.map { return Weekend(rawValue: $0)! })
            
            self.soundNm.accept(data.soundName)
            self.switchVibrate.accept(data.useVibration)
            self.soundVolume.accept(data.soundVolume)
            
            self.snoozeTime.accept(data.snoozeTime)
            self.alarmDesc.accept(data.desc)
        } else {
            self.isEditing = false
        }
    }
    
    // dateFormatter
    //    private lazy var dateFormat: DateFormatter = {
    //        let formatter = DateFormatter()
    //        formatter.dateFormat = "HH : mm a"
    //        return formatter
    //    }()
    
    
    
    //    func transform(input: AlarmDetailVM.Input) -> AlarmDetailVM.Output {
    //
    //    }
    
    func inputData(data: AlarmModel) {
        RealmManager.shared.insert(data: data)
    }
    
    // 해당 시간에서 현재 시간을 뺀 만큼을 알려줘야 함.
    func setRingAlarmTime(_ pickDate: Date, _ repeatDt: [Weekend]) -> String {
        // 1일보다 크다면 ?일 후로 표기.
        var date = pickDate.correctSecondComponent()
        let compareDt = pickDate.dateCompare(fromDate: Date().correctSecondComponent())
        if compareDt == "Future" {
            date = pickDate.calCalendar(byAdding: .day, value: 1)
        }
        
        // 반복 날짜가 있다면, 현재 날로부터의 차이 먼저 구하기.
        if repeatDt.count > 0 {
            // 현재 요일 구하기.
            let curDayWeek = Date().getDayOfTheWeek()
            
            // 현재 요일과 가장 근접한 요일 구하기.
            // 1이 일요일. 6이 토요일.
//            var nearDay = -9
            
            var chkDt = [Int]()
            for dayWeek in repeatDt {
                let diffValue = 7 - curDayWeek
                if dayWeek.rawValue <= curDayWeek {
                    chkDt.append(diffValue - dayWeek.rawValue + 1)
                } else {
                    chkDt.append(diffValue + dayWeek.rawValue)
                }
            }
            
            let timeCompare = pickDate.isFuture()
            let nearWeek = chkDt.sorted{ $0 > $1 }.first
            for (i, nearDay) in chkDt.enumerated() {
                if nearDay == nearWeek {
                    if curDayWeek < repeatDt[i].rawValue {
                        return getWeekDate(pickDate, curDayWeek, repeatDt[i].rawValue, tense: Tense.future)
                    } else if curDayWeek > repeatDt[i].rawValue {
                        return getWeekDate(pickDate, curDayWeek, repeatDt[i].rawValue, tense: Tense.past)
                    } else {
                        if timeCompare {
                            return date.later()
                        } else {
                            return getWeekDate(pickDate, curDayWeek, repeatDt[i].rawValue, tense: Tense.past)
                        }
                    }
                }
            }
//            for dayWeek in repeatDt {
//
//                if dayWeek.rawValue >= curDayWeek {
//                    nearDay = dayWeek.rawValue
//                    let tense = dayWeek.rawValue == curDayWeek ? Tense.present : Tense.future
//                    return getWeekDate(date, curDayWeek, nearDay, tense: tense)
//                }
//            }
//
//            // 해당 요일의 날짜와 현재 날짜의 차이값 구하기.
//            //let currDay =
//            return getWeekDate(date, curDayWeek, nearDay, tense: Tense.future)
            //            nearDay.later()
            
        }
        
        // 반복 날짜가 없으므로, 현재 시간과의 차이 구하기.
        return date.later()
    }
    
    // 해당 날짜의 String값 반환.
    //    func changeDateToString(_ date: Date) -> String {
    //        return date.convertDateToString(strDateFormate: date)
    //    }
    
    // 요일로 Date구하기
    func getWeekDate(_ date: Date, _ curDayWeek: Int, _ weekDay: Int, tense: Tense) -> String {
        // 현재 요일과 가장 근접한 요일 구하기
        var dayCal = 0
        
        // 요번주 월요일 / 일요일 구하기.
        if tense == .past {
            dayCal = 7 + weekDay - curDayWeek
        } else if tense == .future {
            dayCal = weekDay - curDayWeek
        }
        
        let calendar = Calendar.current
        let getDt = calendar.date(byAdding: .day, value: dayCal, to: date) ?? Date()
        log.d("getDt : \(getDt) | \(date) | \(dayCal)")
        
        return getDt.later()
    }
    
    
    func getInitPickerDt() -> Date {
        if let data = schedule {
            // 현재 날짜에 시간만 변경하기.
            let calendar = Date().calendar
            let hour = calendar.component(.hour, from: data.date)
            let minute = calendar.component(.minute, from: data.date)
            let second = calendar.component(.second, from: data.date)
            let date = calendar.date(bySettingHour: hour, minute: minute, second: second, of: Date())!
            log.d("date : \(date)")
            return date
        } else {
            return Date().calCalendar(byAdding: .minute, value: 1)
        }
    }
    
    //MARK: 미션
    func getMissionNmText() -> String {
        let data = mission.value.wakeMission
        return data.getName()
    }
    
    // MARK: 반복 관련 함수
    func getSelectedWeekText() -> String {
        
        let data = repeatDay.value
        if data.count > 0 {
            if data.count == 7 {
                return RepeatDate.all.rawValue
            }
            
            let chkWeekend = data.map{ $0 == Weekend.Sun || $0 == Weekend.Sat }
            let chkWeekdays = data.map{ $0 != Weekend.Sun && $0 != Weekend.Sat}
            
            if !chkWeekend.contains(false) && data.count == 2 {
                return RepeatDate.weekend.rawValue
            } else if !chkWeekdays.contains(false) && data.count == 5 {
                return RepeatDate.weekdays.rawValue
            } else {
                var sData = ""
                for (index,SRepeatDay) in data.enumerated() {
                    if index == data.count - 1 {
                        sData += SRepeatDay.shortDateStr()
                    } else {
                        sData += "\(SRepeatDay.shortDateStr()),"
                    }
                }
                return sData
            }
        }
        
        return RepeatDate.none.rawValue
    }
    
    //MARK: 사운드
    func getSoundNmText() -> String {
        let data = soundNm.value
        return data.getName()
    }
       
    
    //MARK: 다시울림 관련 함수
    func getSnoozeTimeText() -> String {
        let data = snoozeTime.value
        if data > 0 {
            return "\(data)분"
        } else {
            return "사용 안함"
        }
    }
    
    
    //MARK: 팝업창 띄우기.
    // 반복창
    func showRepeatView() -> Observable<AlarmRepeatVC> {
        let storyboard = UIStoryboard.init(name: "Main", bundle: nil)
        let repeatPopupVC = storyboard.instantiateViewController(withIdentifier: "AlarmRepeatVC") as! AlarmRepeatVC
        
        // send data
        let data = repeatDay.value
        log.d("repeatDay data : \(data)")
        let sendVM = AlarmRepeatVM(checkedWeek: data)
        
        sendVM.task.subscribe(onNext: { [weak self] data in
            if let _self = self {
                log.d("repeatDay receive data : \(data)")
                _self.repeatDay.accept(data)
            }
        }).disposed(by: disposeBag)
        
        repeatPopupVC.viewModel = sendVM
        
        
        return Observable.just(repeatPopupVC)
    }
    
    func setVibration() {
        
    }
    
    // 다시 울림창
    func showReRingView() -> Observable<AlarmReRingVC> {
        let storyboard = UIStoryboard.init(name: "Main", bundle: nil)
        let reRingPopupVC = storyboard.instantiateViewController(withIdentifier: "AlarmReRingVC") as! AlarmReRingVC
        
        // send data
        let data =  snoozeTime.value
        let sendVM = AlarmReRingVM.init(checkedTime: data)
        
        sendVM.task.subscribe(onNext: { [weak self] data in
            if let _self = self {
                _self.snoozeTime.accept(data)
            }
        }).disposed(by: disposeBag)
        
        reRingPopupVC.viewModel = sendVM
        
        
        return Observable.just(reRingPopupVC)
    }
    
    
    
    // MARK: Move
    func popViewController() {
        self.steps.accept(AppStep.closeAlarmDetail)
    }
    
    func saveAlarmAndPop() {
        let alarmModel = AlarmModel.init(date: alarmDt.value, mission: mission.value, soundName: soundNm.value, useVibration: switchVibrate.value, soundVolume: soundVolume.value, snoozeTime: snoozeTime.value, desc: alarmDesc.value, used: true, onSnooze: false)
        log.d("soundVolume : \(soundVolume.value) | \(mission) | \(mission.value.wakeMission)")
        for item in repeatDay.value {
            alarmModel.repetition.append(item.rawValue)
        }
        
        inputData(data: alarmModel)
        
        Scheduler.shared.setNotificationWithDate(date: alarmDt.value, soundName: soundNm.value.getFileName() , weekdays: Array(alarmModel.repetition), onSnooze: false, snoozeTime: snoozeTime.value, alarmID: alarmModel.alarmID, vibrartion: switchVibrate.value)
        
        self.task.onNext(true)
        self.steps.accept(AppStep.closeAlarmDetail)
    }
    
    func clickChoiceMission() {
        let viewModel = AlarmMissionVM.init(selected: mission.value)
        viewModel.task.subscribeOn(MainScheduler.instance)
            .bind(to: self.mission)
            .disposed(by: disposeBag)
        
        self.steps.accept(AppStep.selectChoiceAlarmMission(viewModel: viewModel))
    }
    
    func clickChoiceAlarm() {
        let viewModel = AlarmSoundVM.init(soundNm.value)
        viewModel.task.subscribeOn(MainScheduler.instance)
                .bind(to: self.soundNm)
                .disposed(by: disposeBag)
        
        self.steps.accept(AppStep.selectChoiceAlarmSound(viewModel: viewModel))
    }
}
