//
//  Config.swift
//  JHAlarm
//
//  Created by 김제현 on 12/08/2019.
//  Copyright © 2019 김제현. All rights reserved.
//

import Foundation
import SwiftHEXColors

// MARK: URL
let DOMAIN: String = "https://httpbin.org"
let W_DOMAIN: String = "http://api.openweathermap.org"
let ICON_DOMAIN: String = "http://openweathermap.org/img/w/"


// MARK: Color
let COLOR_LIGHT_BG_LIST: UIColor = UIColor(hex: 0xc8c8c8) ?? .white
let COLOR_DARK_BG_LIST: UIColor = UIColor(hex: 0x292a30) ?? .black
let COLOR_DARK_FONT: UIColor = UIColor(hex: 0xffffff) ?? .white
let COLOR_DARK_BG_HEADER: UIColor = UIColor(hex: 0x2b2c2f) ?? .black
let COLOR_DARK_FILL_BUTTON: UIColor = UIColor(hex: 0x88898b) ?? .black
let COLOR_DARK_BG_BUTTON: UIColor = UIColor(hex: 0x3b3c3e) ?? .black
let COLOR_DARK_DIVISION_LINE_DARK_GRAY: UIColor = UIColor(hex: 0x494a4c) ?? .black
let COLOR_DARK_DIVISION_LINE_BLACK: UIColor = UIColor(hex: 0x000000) ?? .black
let COLOR_DARK_DIVISION_LINE_LIGHT_GRAY: UIColor = UIColor(hex: 0xe4e5e8) ?? .black
let COLOR_DIM: UIColor = UIColor(hex: 99000000) ?? .black
let COLOR_NORMAL_DEACTIVE_FONT: UIColor = UIColor(hex: 0xa2a2a3) ?? .black
let COLOR_NORMAL_ACTIVE_FONT: UIColor = .black
let COLOR_NORMAL_FONT_BUTTON: UIColor = UIColor(hex: 0xE4E5E8) ?? .black


// MARK: Identifier
let ID_SNOOZE_ALARM = "JHAlarm_Snooze_identifier"
let ID_STOP_ALARM = "JHAlarm_Stop_identifier"
let ID_ALARM_MODEL = "AlarmModel"
let ID_ALARM_NOTI = "JHAlarm_Alarm_Noti"
let ID_ALARM_NOTI_REQUEST = "JHAlarm_Alarm_Noti_Request"
let ID_WAKEUP_NOTI = "JHAlarm_WakeUp_Noti"

let ID_NOTI_ALARM_SNOOZE_TIME = "ID_NOTI_ALARM_SNOOZE_TIME"
let ID_NOTI_ALARM_ONSNOOZE = "ID_NOTI_ALARM_ONSNOOZE"
let ID_NOTI_ALARM_SOUND_NAME = "ID_NOTI_ALARM_SOUND_NAME"
let ID_NOTI_ALARM_WEEKDAYS = "ID_NOTI_ALARM_WEEKDAYS"
let ID_NOTI_ALARMID = "ID_NOTI_ALARMID"
let ID_NOTI_VIBRATION = "ID_NOTI_VIBRATION"
let ID_NOTI_MISSION = "ID_NOTI_MISSION"

