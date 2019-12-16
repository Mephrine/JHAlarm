//
//  SoundItemCell.swift
//  JHAlarm
//
//  Created by Mephrine on 18/11/2019.
//  Copyright © 2019 김제현. All rights reserved.
//

import Foundation
import UIKit

class SoundItemCell: UITableViewCell {
    @IBOutlet var lbTitle: UILabel!
    @IBOutlet weak var imgCheck: UIImageView!
    
    private var viewModel: SoundItemCellVM!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.selectionStyle = .none
    }
    
    
    func configure(viewModel: SoundItemCellVM) {
        self.viewModel = viewModel
        
        lbTitle.text = viewModel.getSoundNm()
        
        if self.viewModel.getIsSelected() {
            self.imgCheck.image = UIImage(named: "chk_off")
        } else {
            self.imgCheck.image = nil
        }
    }
}
