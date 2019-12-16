//
//  AlarmMissionCellVM.swift
//  JHAlarm
//
//  Created by Mephrine on 05/11/2019.
//  Copyright © 2019 김제현. All rights reserved.
//

import Foundation

class AlarmMissionCellVM {
    var imageNm: String = ""
    var title: String = ""
    var isSelected: Bool
    var collectionViewVM: AlarmMissionVM
    
//    init(selected: Bool) {
//        self.isSelected = selected
//    }
    
    init(viewModel: AlarmMissionVM, element: MissionModel, row: Int) {
        self.collectionViewVM = viewModel
        self.title = element.wakeMission.getName()
        self.imageNm = element.wakeMission.getImgName()
        
        self.isSelected = viewModel.isSelected(row: row)
    }
    
    func toggleAndReturn() -> Bool {
        self.isSelected = !self.isSelected
        
        return self.isSelected
    }
}
