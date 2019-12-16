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
import CocoaLumberjack

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
        case .clickNewAlarm(let viewModel):
            return self.naviToNewAlarm(viewModel)
        case .closeAlarmDetail:
            return self.naviPopAlarmDetail()
        case .selectChoiceAlarmMission(let viewModel):
            return naviToAlarmMission(viewModel)
        case .selectChoiceAlarmSound(let viewModel):
            return naviToAlarmSound(viewModel)
        case .showAlarmMission(let viewModel):
            return naviToAlarmMissionPlay(viewModel)
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
                
//                return .multiple(flowContributors: [.contribute(withNextPresentable: alarmVC, withNextStepper: OneStepper(withSingleStep: alarmVC.viewModel)),
//                .contribute(withNextPresentable: stopWatchVC, withNextStepper: OneStepper(withSingleStep: stopWatchVC.viewModel)) ,
//                .contribute(withNextPresentable: timerVC, withNextStepper: OneStepper(withSingleStep: timerVC.viewModel)) ,
//                .contribute(withNextPresentable: settingVC, withNextStepper: OneStepper(withSingleStep: settingVC.viewModel))])
                return .multiple(flowContributors: [.contribute(withNextPresentable: alarmVC, withNextStepper: alarmVC.viewModel)])
            }
        }
        
        return .none
    }

    private func naviToEditAlarm(_ data: AlarmModel) -> FlowContributors {
        let alarmDetailVC = AlarmDetailVC.instantiate(withViewModel: AlarmDetailVM(schedule: data), storyBoardName: "Main")
        rootViewController.hero.isEnabled = true
        rootViewController.hero.navigationAnimationType = .zoom
        self.rootViewController.pushViewController(alarmDetailVC, animated: true)
        
        return .one(flowContributor: .contribute(withNextPresentable: alarmDetailVC, withNextStepper: alarmDetailVC.viewModel))
    }
    
    private func naviToNewAlarm(_ viewModel: AlarmDetailVM) -> FlowContributors {
        let alarmDetailVC = AlarmDetailVC.instantiate(withViewModel: viewModel, storyBoardName: "Main")
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
    
    
    private func naviToAlarmMission(_ viewModel: AlarmMissionVM) -> FlowContributors {
        // flow
//        let service = AlarmService(selectedMission: currentMission)
        
        let missionFlow = AlarmMissionFlow()
        Flows.whenReady(flow1: missionFlow) { (root) in
            Async.main {
                self.rootViewController.present(root, animated: true)
            }
        }
        return .one(flowContributor: .contribute(withNextPresentable: missionFlow, withNextStepper: OneStepper(withSingleStep: AppStep.selectChoiceAlarmMission(viewModel: viewModel))))
    }
    
    private func naviToAlarmSound(_ viewModel: AlarmSoundVM) -> FlowContributors {
        //flow
//        let service = AlarmService(selectedSound: currentSound)
        
        let missionFlow = AlarmMissionFlow()
        Flows.whenReady(flow1: missionFlow) { (root) in
            Async.main {
                self.rootViewController.present(root, animated: true)
            }
        }
        
        return .one(flowContributor: .contribute(withNextPresentable: missionFlow, withNextStepper: OneStepper(withSingleStep: AppStep.selectChoiceAlarmSound(viewModel: viewModel))))
    }
    
    private func naviToAlarmMissionPlay(_ viewModel: AlarmMissionPlayVM) -> FlowContributors {
        //        let missionVC = AlarmMissionVC.instantiate(withViewModel: viewModel, storyBoardName: "Main")
        let missionPlayVC = AlarmMissionPlayVC.instantiate(withViewModel: viewModel, storyBoardName: "Main")
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
