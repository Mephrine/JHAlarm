//
//  MainVC.swift
//  JHAlarm
//
//  Created by 김제현 on 12/08/2019.
//  Copyright © 2019 김제현. All rights reserved.
//

import UIKit
import SPPermission
import Reusable
import SwiftyUserDefaults

class MainVC: BaseVC, StoryboardBased {
    @IBOutlet var containerView: UIView!
    
    var menuVC: BaseVC!
    var currentIndex = MenuConfig.Alarm.hashValue
    var footerView: FooterMenuView?
    var viewControllers: [BaseVC]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.initFooterView()
        
        self.moveToMenu(MenuConfig.Alarm.rawValue)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let alarmID = Defaults[.UD_PLAY_MISSION] ?? ""
        if !alarmID.isEmpty {
            let viewModel = AlarmMissionPlayVM(alarmID: alarmID)
            let missionPlayVC = AlarmMissionPlayVC.instantiate(withViewModel: viewModel, storyBoardName: "Main")
            if let root = UIApplication.shared.windows.first!.rootViewController {
                root.present(missionPlayVC, animated: true)
            }
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }
    
    deinit {
        
    }
    
    /// 메인 컨트롤러에 연결되어 있는, Child 컨트롤러 Remove
    func removeChildView() {
        if let vc = self.menuVC {
            self.menuVC = nil
            vc.willMove(toParent: nil)
            vc.view.removeFromSuperview()
            vc.removeFromParent()
        }
    }
    
    func moveToController(_ vc: BaseVC) {
        self.removeChildView()
        
        self.menuVC = vc
        self.addChild(self.menuVC)
        self.menuVC.view.frame = self.containerView.frame
        self.containerView.addSubview(self.menuVC.view)
        self.menuVC.didMove(toParent: self)
        vc.initView()
        
        self.view.layoutIfNeeded()
    }
    
    /**
     메뉴 탭 이동, 컨테이너 뷰에 해당 탭 컨트롤러를 attach
     - Parameters:
     - index : 이동하고자 하는 탭의 index 값(== MenuConfig)
     */
    func moveToMenu(_ index: Int) {
        self.currentIndex = index
        
        let vc = self.viewControllers[index]
        if vc == self.menuVC {
            self.menuVC.resetView()
            return
        }
        self.moveToController(vc)
        self.footerView?.animIndicatorBar(index)
    }
}

// Footer 관련
extension MainVC {
    /// 메뉴 Footer 생성 및 초기화
    func initFooterView() {
        self.footerView = FooterMenuView.initView(self.view, menuBtnHandler: { (index) in
            self.footerView?.selectTab(index: index)
            self.moveToMenu(index)
        })
        
        self.view.layoutIfNeeded()
        print("footerInset2 : \(footerInset)")
    }
    /// Footer가 슬라이드 Up되면서 나타나는 애니메이션
    func animShowFooter(){
        self.footerView?.showFooter()
        UIView.animate(withDuration: 0.3, animations: {
            self.view.layoutIfNeeded()
        })
    }
    /// Footer가 슬라이드 Down되면서 사라지는 애니메이션
    func animHideFooter(){
        self.footerView?.hideFooter()
        UIView.animate(withDuration: 0.3, animations: {
            self.view.layoutIfNeeded()
        })
    }
}
