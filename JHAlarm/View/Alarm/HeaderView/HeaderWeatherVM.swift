//
//  HeaderWeatherVM.swift
//  JHAlarm
//
//  Created by Mephrine on 2019/11/28.
//  Copyright © 2019 김제현. All rights reserved.
//

import Foundation
import RxSwift

class HeaderWeatherVM {
    var weatherText = ""
    var imgWeatherURL: URL?
    
    var isShown: Bool = false
    
    init(_ text: String, _ url: URL?) {
        self.weatherText = text
        self.imgWeatherURL = url
        self.isShown = true
    }
    
}

