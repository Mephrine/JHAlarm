//
//  AlarmFlow.swift
//  JHAlarm
//
//  Created by Mephrine on 13/11/2019.
//  Copyright © 2019 김제현. All rights reserved.
//

import Foundation
import UIKit
import RxFlow
import RxCocoa
import RxSwift
import CocoaLumberjack

// 메인 네비게이션쪽 처리하는 Flow
class AlarmMissionFlow: Flow {
    var root: Presentable {
        return rootViewController
    }
    
    private lazy var rootViewController: UINavigationController = {
        let viewController = UINavigationController()
        viewController.setNavigationBarHidden(true, animated: false)
        return viewController
    }()
    
    func navigate(to step: Step) -> FlowContributors {
        guard let step = step as? AppStep else { .none }
        
        switch step {
        case .:
            return
        default:
            return .none
        }
    }
    
    
}
