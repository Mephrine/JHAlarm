//
//  HeaderWeatherView.swift
//  JHAlarm
//
//  Created by 김제현 on 30/09/2019.
//  Copyright © 2019 김제현. All rights reserved.
//

import Foundation

class HeaderWeatherView: UIView {
    @IBOutlet var lbWeather: UILabel!
    @IBOutlet var ivWeather: UIImageView!
    
    let viewModel = HeaderWeatherVM()
    
    func setBind() {
        
    }
}
