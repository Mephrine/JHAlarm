//
//  UserDefaultExtension.swift
//  JHAlarm
//
//  Created by 김제현 on 12/08/2019.
//  Copyright © 2019 김제현. All rights reserved.
//

import Foundation
import SwiftyUserDefaults

extension DefaultsKeys {
//    //push
    static let USER_PUSH_MESSAGE          = DefaultsKey<[String]?>("USER_PUSH_MESSAGE")

    //현재 접속 중인 국가 정보 가져오기.
    static let USER_ACCESS_COUNTRY          = DefaultsKey<String?>("USER_ACCESS_COUNTRY")

    //최신버전인지 저장.
    static let USER_LATEST_VERSION          = DefaultsKey<Bool?>("USER_LATEST_VERSION")

    static let UD_PLAY_MISSION          = DefaultsKey<String?>("UD_PLAY_MISSION")
    

     //push
//     var pushMessage: DefaultsKey<[String]?> {.init("USER_PUSH_MESSAGE")}
//
//     //현재 접속 중인 국가 정보 가져오기.
//     var accessCountry: DefaultsKey<String?> {.init("USER_ACCESS_COUNTRY")}
//
//     //최신버전인지 저장.
//     var latestVersion: DefaultsKey<Bool?> {.init("USER_LATEST_VERSION")}
//
//     var playMission: DefaultsKey<String?> {.init("UD_PLAY_MISSION")}

}


