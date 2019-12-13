//
//  Weather.swift
//  JHAlarm
//
//  Created by 김제현 on 24/09/2019.
//  Copyright © 2019 김제현. All rights reserved.
//

import Foundation
import Moya_SwiftyJSONMapper
import SwiftyJSON

class Weather : ALSwiftyJSONAble {
    let main: WeatherMain?
    let weather: [WeatherSub]?
    
    required init?(jsonData:JSON){
        self.main = jsonData["main"].to(type: WeatherMain.self) as? WeatherMain
        self.weather = jsonData["weather"].to(type: WeatherSub.self) as? [WeatherSub] ?? []
    }
    
}

class WeatherMain: ALSwiftyJSONAble {
    let humidity: Double
    let pressure: Double
    var temp: String
    var tempMax: String
    var tempMin: String
    
    required init?(jsonData:JSON){
        self.humidity = jsonData["humidity"].doubleValue
        self.pressure = jsonData["pressure"].doubleValue
        var dTemp = jsonData["temp"].doubleValue
        var dTempMax = jsonData["temp_max"].doubleValue
        var dTempMin = jsonData["temp_min"].doubleValue
        
        // 화씨 -> 섭씨로 변경
        if dTemp > 0.0 {
            dTemp -= 273.15
        }
        self.temp = dTemp.toCelsius
        
        if dTempMax > 0 {
            dTempMax -= 273.15
        }
        self.tempMax = dTempMax.toCelsius
        
        if dTempMin > 0 {
            dTempMin -= 273.15
        }
        self.tempMin = dTempMin.toCelsius
        
    }
}

class WeatherSub: ALSwiftyJSONAble {
    let main: String?
    let description: String?
    let icon: URL?
    
    required init?(jsonData:JSON){
        self.main = jsonData["main"].stringValue
        self.description = jsonData["description"].stringValue
        let strIcon = jsonData["icon"].stringValue
        self.icon = URL(string: "\(ICON_DOMAIN)\(strIcon).png")
    }
}
