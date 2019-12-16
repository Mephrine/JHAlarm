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
import RealmSwift
import RxSwift

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
        self.selectionStyle = .none
    }
    
    func configure(_ data: AlarmModel) {
        let isUsed = data.used
        if isUsed {
            
        } else {
            
        }
        self.lbMeridiem.text = data.date.dateSymbol
        self.lbTime.text = data.date.time
        self.swAlarm.isOn = isUsed
        let imgOnOff = isUsed ? "_on" : "_off"
        if let missionNm = data.mission?.wakeMission.getImgName() {
            self.imgMission.image = UIImage(named: #"\#(missionNm)\#(imgOnOff)"#)
        }
        
        self.choiceDay(dates: data.repetition)
    }
    
    func configure(_ data: String) {
        if lbMeridiem != nil {
            lbMeridiem.text = data
        }
    }
    
    func choiceDay(dates: List<Int>) {
//        dates.forEach({ dateInt in
        for view in self.stvDay.arrangedSubviews {
            if let childView = view as? UILabel {
                let dateHashValue = view.tag - 100
                let isChoice = Array(dates).map{ dateHashValue == $0 }.filter { $0 }.first ?? false
                
                if isChoice {
                    childView.setFontBold(17, .white)
                } else {
                    childView.setFontRegular(17, .lightGray)
                }
            }
        }
    }
    
    @IBAction func ChangeSwitchAlarm(_ sender: Any) {
        self.swAlarm.isOn = !self.swAlarm.isOn
    }
    
}
