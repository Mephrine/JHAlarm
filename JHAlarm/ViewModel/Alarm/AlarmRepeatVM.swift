//
//  AlarmRepeatVM.swift
//  JHAlarm
//
//  Created by Mephrine on 10/10/2019.
//  Copyright © 2019 김제현. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

class AlarmRepeatVM {
    var disposeBag = DisposeBag()
    var manageCheckWeek = [Weekend]()
    
    
    // Send Detail to List
    let task = PublishSubject<[Weekend]>()
    
    init(checkedWeek: [Weekend]) {
        self.manageCheckWeek = checkedWeek
    }
    
    func setChecked(tag: Int) -> Bool {
        let nTag = tag % 100
        for day in self.manageCheckWeek {
            if day.rawValue == nTag {
                self.manageCheckWeek = self.manageCheckWeek.removed(day)
                return false
            }
        }
        self.manageCheckWeek.append(Weekend(rawValue: nTag)!)
        return true
    }
    
    func isChecked(tag: Int) -> Bool {
        for day in self.manageCheckWeek {
            if day.rawValue == tag {
                return true
            }
        }
        return false
    }
    
    func isCheckedColor(checked: Bool) -> UIColor {
        if checked {
            return COLOR_NORMAL_ACTIVE_FONT
        } else {
            return COLOR_NORMAL_DEACTIVE_FONT
        }
    }
    
    func sendCheckedData() {
        self.task.onNext(manageCheckWeek.sorted{ $0.rawValue < $1.rawValue })
    }
}
