//
//  AlarmTableCell.swift
//  JHAlarm
//
//  Created by 김제현 on 02/09/2019.
//  Copyright © 2019 김제현. All rights reserved.
//

import UIKit
//import SwipeCellKit
import Reusable

final class AlarmTableCell: UITableViewCell, NibReusable {
    
    static var reuseIdentifier = "AlarmTableCell"
    
    // 오전/오후
    @IBOutlet var lbMeridiem: UILabel!
    // 시:분
    @IBOutlet var lbTime: UILabel!
    // 스위치
    @IBOutlet var swAlarm: UISwitch!
    
    @IBOutlet var imgMission: UIImageView!
    
    @IBOutlet var stvDay: UIStackView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
    }
    
    func configure(_ data: AlarmModel) {
        
    }
    
    func configure(_ data: String) {
        if lbMeridiem != nil {
            lbMeridiem.text = data
        }
    }
    
    @IBAction func ChangeSwitchAlarm(_ sender: Any) {
        
    }
    
}
