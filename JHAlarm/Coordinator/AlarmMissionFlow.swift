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
    
    private lazy var btnClose = UIBarButtonItem()
    
    
    let task = PublishSubject<AlarmModel>()
    
//    let service: AlarmService
//
//    init(withService: AlarmService) {
//        service = withService
//    }
    
    func navigate(to step: Step) -> FlowContributors {
        guard let step = step as? AppStep else { return .none }
        
        switch step {
        case .selectChoiceAlarmMission(let viewModel):
            return naviToAlarmMission(viewModel)
        case .closeAlarmMission:
            self.rootViewController.dismiss(animated: true)
            return .none
            
        case .selectAlarmMissionArithmetic(let viewModel):
            return naviToMissionArithmetic(viewModel)
        case .selectAlarmMissionShake(let viewModel):
            return naviToMissionShake(viewModel)
        case .setUpAlarmMissionArithmetic:
            return naviDismissMissionArithmetic()
        case .setUpAlarmMissionShake:
            return naviDismissMissionShake()
        case .backAlarmMissionArithmetic:
            return naviPopMissionArithmetic()
        case .backAlarmMissionShake:
            return naviPopMissionShake()
        case .selectChoiceAlarmSound(let viewModel):
            return naviToAlarmSound(viewModel)
        case .closeAlarmSound:
            self.rootViewController.dismiss(animated: true)
            return .none
        default:
            return .none
        }
    }
    
//    private func naviToAlarmMission(_ viewModel: AlarmMissionVM) -> FlowContributors {
//        let missionVC = AlarmMissionVC.instantiate(withViewModel: viewModel, storyBoardName: "Main")
//
//        self.rootViewController.setViewControllers([missionVC], animated: false)
//        if let navigationBarItem
//
//        return .one(flowContributor: .contribute(withNextPresentable: missionVC, withNextStepper: viewModel))
//    }
    
    // 네비게이션 써보기.
    private func naviToAlarmMission(_ viewModel: AlarmMissionVM) -> FlowContributors {
//        let missionVC = AlarmMissionVC.instantiate(withViewModel: viewModel, storyBoardName: "Main")
        let missionVC = AlarmMissionTestVC.instantiate(withViewModel: viewModel, storyBoardName: "Main")
        
        self.rootViewController.setViewControllers([missionVC], animated: false)
        self.rootViewController.setNavigationBarHidden(false, animated: false)
        
        if btnClose.image == nil {
            btnClose.image = UIImage(named: "common_close")
            btnClose.style = .plain
            btnClose.target = viewModel
            btnClose.action = #selector(viewModel.dismiss)
        }
        
        let naviItem = UIBarButtonItem.init(barButtonSystemItem: .stop, target: viewModel, action: #selector(viewModel.dismiss))
        naviItem.tintColor = .black
        missionVC.navigationItem.rightBarButtonItem = naviItem
               
        
//        if let navigationBarItem = self.rootViewController.navigationBar.items?[0] {
//            navigationBarItem.setRightBarButton(btnClose, animated: true)
//        }
        
        return .one(flowContributor: .contribute(withNextPresentable: missionVC, withNextStepper: viewModel))
    }
    
    private func naviToMissionArithmetic(_ viewModel: AlarmMissionArithmeticVM) -> FlowContributors {
        let missionArithmeticVC = AlarmMissionArithmeticVC.instantiate(withViewModel: viewModel, storyBoardName: "Main")
        
        missionArithmeticVC.title = "사칙연산"
        
        let button = UIButton().then {
            $0.addTarget(viewModel, action: #selector(viewModel.popViewController), for: .touchUpInside)
            $0.setBackgroundImage(UIImage(named: "common_back"), for: .normal)
        }
//        let naviItem = UIBarButtonItem.init(barButtonSystemItem: image, style: .plain, target: viewModel, action: #selector(viewModel.popViewController))
        
        let naviItem = UIBarButtonItem.init(customView: button)
        naviItem.customView?.snp.makeConstraints {
            $0.width.height.equalTo(40)
        }
        
        naviItem.tintColor = .black
        missionArithmeticVC.navigationItem.leftBarButtonItem = naviItem
        
//        if let navigationBarItem = self.rootViewController.navigationBar.items?[0] {
//            navigationBarItem.rightBarButtonItems = []
//            navigationBarItem.setLeftBarButton(UIBarButtonItem.init(image: UIImage(named: "common_back"), style: .plain, target: viewModel, action: #selector(viewModel.popViewController)), animated: true)
//
//        }
        
        self.rootViewController.pushViewController(missionArithmeticVC, animated: true)
        
        return .one(flowContributor: .contribute(withNextPresentable: missionArithmeticVC, withNextStepper: viewModel))
    }
    
    private func naviPopMissionArithmetic() -> FlowContributors {
//        if let navigationBarItem = self.rootViewController.navigationBar.items?[0] {
//            navigationBarItem.leftBarButtonItems = []
//            navigationBarItem.setRightBarButton(btnClose, animated: true)
//        }
        self.rootViewController.popViewController(animated: true)
        
        return .none
    }
    
    private func naviDismissMissionArithmetic() -> FlowContributors {
        self.rootViewController.dismiss(animated: true)
        
        return .none
    }
    
    private func naviToMissionShake(_ viewModel: AlarmMissionShakeVM) -> FlowContributors {
        let missionShakeVC = AlarmMissionShakeVC.instantiate(withViewModel: viewModel, storyBoardName: "Main")
        
        missionShakeVC.title = "흔들기"
        
        let button = UIButton().then {
                   $0.addTarget(viewModel, action: #selector(viewModel.popViewController), for: .touchUpInside)
                   $0.setBackgroundImage(UIImage(named: "common_back"), for: .normal)
               }
        
        let naviItem = UIBarButtonItem.init(customView: button)
        naviItem.customView?.snp.makeConstraints {
            $0.width.height.equalTo(40)
        }
        
        missionShakeVC.navigationItem.leftBarButtonItem = naviItem
//        if let navigationBarItem = self.rootViewController.navigationBar.items?[0] {
//            navigationBarItem.rightBarButtonItems = []
//            navigationBarItem.
//        }
        
        self.rootViewController.pushViewController(missionShakeVC, animated: true)
        
        return .one(flowContributor: .contribute(withNextPresentable: missionShakeVC, withNextStepper: viewModel))
    }
    
    private func naviPopMissionShake() -> FlowContributors {
//        if let navigationBarItem = self.rootViewController.navigationBar.items?[0] {
//            navigationBarItem.leftBarButtonItems = []
//            navigationBarItem.setRightBarButton(btnClose, animated: true)
//        }
        
        self.rootViewController.popViewController(animated: true)
        
        return .none
    }
    
    private func naviDismissMissionShake() -> FlowContributors {
        self.rootViewController.dismiss(animated: true)
        
        return .none
    }
    
    private func naviPopSelectedAlarmMission(_ selected: Mission) -> FlowContributors {
        return .none
    }
    
    private func naviToAlarmSound(_ viewModel: AlarmSoundVM) -> FlowContributors {
        let soundVC = AlarmSoundVC.instantiate(withViewModel: viewModel, storyBoardName: "Main")
        self.rootViewController.setViewControllers([soundVC], animated: false)
        
        return .one(flowContributor: .contribute(withNextPresentable: soundVC, withNextStepper: viewModel))
    }
    
    private func naviPopSelectedAlarmSound(_ selected: AlarmSound) -> FlowContributors {
        
        
        return .none
    }
    
    
}
