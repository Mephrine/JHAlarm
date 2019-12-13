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
    var manageCheckWeek: [Int]
    
    init(checkedWeek: [Int]) {
        self.manageCheckWeek = checkedWeek
    }
    
    func isChecked(tag: Int) -> Bool {
        for day in self.manageCheckWeek {
            if day == tag {
                self.manageCheckWeek.removed(day)
                return false
            }
        }
        self.manageCheckWeek.append(tag)
        return true
    }
}
