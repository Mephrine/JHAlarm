//
//  AlarmMissionModel.swift
//  JHAlarm
//
//  Created by Mephrine on 20/11/2019.
//  Copyright © 2019 김제현. All rights reserved.
//

import RxDataSources

struct AlarmMissionModel {
    var header: String
    var items: [MissionModel]
}

extension AlarmMissionModel: SectionModelType {
    typealias Item = MissionModel
    
    var identity: String {
        return header
    }
    
    init(original: AlarmMissionModel, items: [MissionModel]) {
        self = original
        self.items = items
    }
}

