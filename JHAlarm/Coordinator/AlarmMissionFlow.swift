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
    
    func navigate(to step: Step) -> FlowContributors {
        guard let step = step as? AppStep else { return .none }
        
        switch step {
        case .selectChoiceAlarmMission(let selected, let task):
            return naviToAlarmMission(selected, task)
        case .closeAlarmMission:
            self.rootViewController.dismiss(animated: true)
            return .none
        case .selectAlarmMissionArithmetic(let task):
            return naviToMissionArithmetic(task)
        case .selectAlarmMissionShake(let task):
            return naviToMissionShake(task)
        case .setUpAlarmMissionArithmetic:
            return naviDismissMissionArithmetic()
        case .setUpAlarmMissionShake:
            return naviDismissMissionShake()
        case .backAlarmMissionArithmetic:
            return naviPopMissionArithmetic()
        case .backAlarmMissionShake:
            return naviPopMissionShake()
        case .selectChoiceAlarmSound(let initSound, let task):
            return naviToAlarmSound(initSound, task)
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
    
    private func naviToAlarmMission(_ selected: MissionModel,_ task: PublishSubject<MissionModel>) -> FlowContributors {
        let missionVC = AlarmMissionTestVC.instantiate(storyBoardName: "Main")
        
        self.rootViewController.setViewControllers([missionVC], animated: false)
        self.rootViewController.setNavigationBarHidden(false, animated: false)
        
        guard let viewModel = Global.appDelegate.container.resolve(AlarmMissionVM.self) else { return .none }
        
        if btnClose.image == nil {
            btnClose.image = UIImage(named: "common_close")
            btnClose.style = .plain
            btnClose.target = viewModel
            btnClose.action = #selector(viewModel.dismiss)
        }
        
        let naviItem = UIBarButtonItem.init(barButtonSystemItem: .stop, target: viewModel, action: #selector(viewModel.dismiss))
        naviItem.tintColor = .black
        missionVC.navigationItem.rightBarButtonItem = naviItem
            
        return .one(flowContributor: .contribute(withNextPresentable: missionVC, withNextStepper: viewModel))
    }
    
    private func naviToMissionArithmetic(_ task: PublishSubject<MissionModel?>) -> FlowContributors {
        let container = Global.appDelegate.container
        container.register(AlarmMissionArithmeticVM.self) { _ in AlarmMissionArithmeticVM(task: task) }
        
        let missionArithmeticVC = AlarmMissionArithmeticVC.instantiate(storyBoardName: "Main")
        
        missionArithmeticVC.title = "사칙연산"
        let viewModel = container.resolve(AlarmMissionArithmeticVM.self)
        let button = UIButton().then {
            $0.addTarget(viewModel, action: #selector(viewModel?.popViewController), for: .touchUpInside)
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
        
        return .one(flowContributor: .contribute(withNextPresentable: missionArithmeticVC, withNextStepper: viewModel!))
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
    
    private func naviToMissionShake(_ task: PublishSubject<MissionModel?>) -> FlowContributors {
        let container = Global.appDelegate.container
        container.register(AlarmMissionShakeVM.self) { _ in AlarmMissionShakeVM(task: task) }
        let missionShakeVC = AlarmMissionShakeVC.instantiate(storyBoardName: "Main")
        
        missionShakeVC.title = "흔들기"
        let viewModel = container.resolve(AlarmMissionShakeVM.self)
        
        let button = UIButton().then {
                   $0.addTarget(viewModel, action: #selector(viewModel?.popViewController), for: .touchUpInside)
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
        
        return .one(flowContributor: .contribute(withNextPresentable: missionShakeVC, withNextStepper: viewModel!))
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
    
    private func naviToAlarmSound(_ initSound: AlarmSound, _ task: PublishSubject<AlarmSound>) -> FlowContributors {
        let container = Global.appDelegate.container
        container.register(AlarmSoundVM.self) { _ in AlarmSoundVM(initSound, task: task) }
        
        let viewModel = container.resolve(AlarmSoundVM.self)
        
        let soundVC = AlarmSoundVC.instantiate(storyBoardName: "Main")
        self.rootViewController.setViewControllers([soundVC], animated: false)
        
        return .one(flowContributor: .contribute(withNextPresentable: soundVC, withNextStepper: viewModel!))
    }
    
    private func naviPopSelectedAlarmSound(_ selected: AlarmSound) -> FlowContributors {
        
        
        return .none
    }
    
    
}
