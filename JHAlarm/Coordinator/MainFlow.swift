//
//  MainFlow.swift
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
import Swinject

// 메인 네비게이션쪽 처리하는 Flow
class MainFlow: Flow {
    var root: Presentable {
        return self.rootViewController
    }
    
    private lazy var rootViewController: UINavigationController = {
        let viewController = UINavigationController()
        viewController.setNavigationBarHidden(true, animated: false)
        return viewController
    }()
    
    private let service: AppService
    
    init(service: AppService) {
        self.service = service
    }
    
    deinit {
        log.d("deinit MainFlow")
    }
    
    func navigate(to step: Step) -> FlowContributors {
        guard let step = step as? AppStep else { return .none }
        
        switch step {
        case .goMain:
            return self.initMain()
        case .selectAlarmEdit(let alarmData):
            return self.naviToEditAlarm(alarmData)
        case .clickNewAlarm(let task):
            return self.naviToNewAlarm(task)
        case .closeAlarmDetail:
            return self.naviPopAlarmDetail()
        case .selectChoiceAlarmMission(let selected, let task):
            return naviToAlarmMission(selected, task)
        case .selectChoiceAlarmSound(let initSound, let task):
            return naviToAlarmSound(initSound, task)
        case .showAlarmMission(let alarmId, let task):
            return naviToAlarmMissionPlay(alarmId, task)
        case .completeAlarmMission:
            return dismissToAlarmMissionPlay()
        default:
            return .none
        }
    }
    
    
    func initMenus(){
        
       
    }
    
    //MARK: Set Navigation
    private func initMain() -> FlowContributors {
        let sb = UIStoryboard.init(name: "Main", bundle: nil)
        if let mainVC = sb.instantiateViewController(withIdentifier: String(describing: "MainVC")) as? MainVC {
            self.rootViewController.pushViewController(mainVC, animated: false)
            
            if let alarmVC    = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "AlarmVC") as? AlarmVC,
                let stopWatchVC   = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "StopWatchVC") as? StopWatchVC,
                let timerVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "TimerVC") as? TimerVC,
                let settingVC   = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "SettingVC") as? SettingVC {
                   
                mainVC.viewControllers = [alarmVC, stopWatchVC, timerVC, settingVC]
                return .multiple(flowContributors: [.contribute(withNextPresentable: alarmVC, withNextStepper: alarmVC.viewModel!)])
            }
        }
        
        return .none
    }

    private func naviToEditAlarm(_ data: AlarmModel) -> FlowContributors {
        let container = Global.appDelegate.container
        container.register(AlarmDetailVM.self) { _ in AlarmDetailVM(schedule: data) }
        
        let alarmDetailVC = AlarmDetailVC.instantiate(storyBoardName: "Main")
        rootViewController.hero.isEnabled = true
        rootViewController.hero.navigationAnimationType = .zoom
        self.rootViewController.pushViewController(alarmDetailVC, animated: true)
        
        return .one(flowContributor: .contribute(withNextPresentable: alarmDetailVC, withNextStepper: alarmDetailVC.viewModel!))
    }
    
    private func naviToNewAlarm(_ task: PublishSubject<Bool>) -> FlowContributors {
        let container = Global.appDelegate.container
        container.register(AlarmDetailVM.self) { _ in AlarmDetailVM(schedule: nil, task: task) }
        
        let alarmDetailVC = AlarmDetailVC.instantiate(storyBoardName: "Main")
        rootViewController.hero.isEnabled = true
        rootViewController.hero.navigationAnimationType = .zoom
        self.rootViewController.pushViewController(alarmDetailVC, animated: true)
        
        return .one(flowContributor: .contribute(withNextPresentable: alarmDetailVC, withNextStepper: alarmDetailVC.viewModel))
    }
    
    private func naviPopAlarmDetail() -> FlowContributors {
        self.rootViewController.hero.isEnabled = true
        self.rootViewController.hero.navigationAnimationType = .zoomOut
        self.rootViewController.popViewController(animated: true)
        
        return .none
    }
    
    
    private func naviToAlarmMission(_ selected: MissionModel, _ task: PublishSubject<MissionModel>) -> FlowContributors {
        // flow
//        let service = AlarmService(selectedMission: currentMission)
        
        let container = Global.appDelegate.container
        container.register(AlarmMissionVM.self) { _ in AlarmMissionVM(selected: selected, task: task) }
        
        let missionFlow = AlarmMissionFlow()
        Flows.whenReady(flow1: missionFlow) { (root) in
            Async.main {
                self.rootViewController.present(root, animated: true)
            }
        }
        return .one(flowContributor: .contribute(withNextPresentable: missionFlow, withNextStepper: OneStepper(withSingleStep: AppStep.selectChoiceAlarmMission(selected: selected, task: task))))
    }
    
    private func naviToAlarmSound(_ selected: AlarmSound, _ task: PublishSubject<AlarmSound>) -> FlowContributors {
        //flow
//        let service = AlarmService(selectedSound: currentSound)
        
        let container = Global.appDelegate.container
        container.register(AlarmSoundVM.self) { _ in AlarmSoundVM(selected, task: task) }
        
        let missionFlow = AlarmMissionFlow()
        Flows.whenReady(flow1: missionFlow) { (root) in
            Async.main {
                self.rootViewController.present(root, animated: true)
            }
        }
        
        return .one(flowContributor: .contribute(withNextPresentable: missionFlow, withNextStepper: OneStepper(withSingleStep: AppStep.selectChoiceAlarmSound(initSound: selected, task: task))))
    }
    
    private func naviToAlarmMissionPlay(_ alarmId: String, _ task: PublishSubject<MissionModel?>) -> FlowContributors {
        let container = Global.appDelegate.container
        container.register(AlarmMissionPlayVM.self) { _ in AlarmMissionPlayVM(alarmID: alarmId, task: task) }
        
        let missionPlayVC = AlarmMissionPlayVC.instantiate(storyBoardName: "Main")
        if let root = UIApplication.shared.windows.first!.rootViewController {
            root.present(missionPlayVC, animated: true)
        }
        
        return .none
    }
    
    private func dismissToAlarmMissionPlay() -> FlowContributors {
        //        let missionVC = AlarmMissionVC.instantiate(withViewModel: viewModel, storyBoardName: "Main")
        if let root = UIApplication.shared.windows.first!.rootViewController {
            root.dismiss(animated: true)
        }
        
        return .none
    }
    
}

class MainStepper: Stepper {
    var steps = PublishRelay<Step>()
    
    var initialStep: Step {
        return AppStep.goMain
    }
    
    func readyToEmitSteps() {
        
    }
}
