//
//  AlarmReRingVM.swift
//  JHAlarm
//
//  Created by Mephrine on 16/10/2019.
//  Copyright © 2019 김제현. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

class AlarmReRingVM {
    var disposeBag = DisposeBag()
    var manageCheckTime: Int = 0
    
    // Send Detail to List
    let task = PublishSubject<Int>()
    
    init(checkedTime: Int) {
        self.manageCheckTime = checkedTime
    }
    
    func setChecked(tag: Int) {
        self.manageCheckTime = self.changeTagToTime(tag: tag)
    }
    
    func isCheckedTag() -> Int {
        return changeTimeToTag(time: manageCheckTime)
    }
    
    func sendCheckedData() {
        self.task.onNext(manageCheckTime)
    }
    
    func changeTagToTime(tag: Int) -> Int {
        switch tag {
        case 0:
            return 0
        case 1:
            return 1
        case 2:
            return 3
        case 3:
            return 5
        case 4:
            return 10
        case 5:
            return 30
        case 6:
            return 60
        default:
            return 0
        }
    }
    
    func changeTimeToTag(time: Int) -> Int {
        switch time {
        case 0:
            return 0
        case 1:
            return 1
        case 3:
            return 2
        case 5:
            return 3
        case 10:
            return 4
        case 30:
            return 5
        case 60:
            return 6
        default:
            return 0
        }
    }
}

