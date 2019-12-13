//
//  AlarmSectionModel.swift
//  JHAlarm
//
//  Created by 김제현 on 09/09/2019.
//  Copyright © 2019 김제현. All rights reserved.
//

import Foundation

struct AlarmSectionModel {
    var header: String
    var items: [AlarmModel]
}

extension AlarmSectionModel {
    typealias Item = AlarmModel
    
    var identity: String {
        return header
    }
    
    init(original: AlarmSectionModel, items: [AlarmModel]) {
        self = original
        self.items = items
    }
}
