//
//  SoundItemCellVM.swift
//  JHAlarm
//
//  Created by Mephrine on 18/11/2019.
//  Copyright © 2019 김제현. All rights reserved.
//

import Foundation

class SoundItemCellVM {
    private var title: String
    private var isSelected: Bool

    init(item: SoundSection.Item, isSelected: Bool) {
        self.title = item.getName()
        self.isSelected = isSelected
    }
    
    func getIsSelected() -> Bool {
        return isSelected
    }
    
    func getSoundNm() -> String {
        return self.title
    }
}
