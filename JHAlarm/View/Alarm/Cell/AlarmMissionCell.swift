//
//  AlarmMissionCell.swift
//  JHAlarm
//
//  Created by Mephrine on 05/11/2019.
//  Copyright © 2019 김제현. All rights reserved.
//

import Foundation
import Reusable

class AlarmMissionCell: UICollectionViewCell, NibReusable {
    @IBOutlet weak var imgIcon: UIImageView!
    @IBOutlet weak var lbTitle: UILabel!
    
    private var viewModel: AlarmMissionCellVM?
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func configure(viewModel: AlarmMissionCellVM) {
        self.viewModel = viewModel
        lbTitle.text = viewModel.title
        self.setSelected(viewModel.isSelected)
    }
    
    private func setSelected(_ isSelected: Bool) {
        guard let vm = viewModel else {
            return
        }
        if isSelected {
            lbTitle.textColor = COLOR_NORMAL_ACTIVE_FONT
            imgIcon.image = UIImage(named:"\(vm.imageNm)_on")
        } else {
            lbTitle.textColor = COLOR_NORMAL_DEACTIVE_FONT
            imgIcon.image = UIImage(named:"\(vm.imageNm)_off")
        }
    }
    
    // CollectionView에서 Select 됐을 때 불림.
    func setToggle() {
        guard let toggle = viewModel?.toggleAndReturn() else {
            return
        }
        self.setSelected(toggle)
    }
}
