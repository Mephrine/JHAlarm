//
//  MainService.swift
//  JHAlarm
//
//  Created by Mephrine on 13/11/2019.
//  Copyright © 2019 김제현. All rights reserved.
//

import Foundation
import RxSwift

protocol HasAppService {
    var appService: AppService { get }
}

class AppService {
    
}

extension AppService: ReactiveCompatible {}

extension Reactive where Base: AppService {
    
}
