//
//  AlarmRepeatVC.swift
//  JHAlarm
//
//  Created by 김제현 on 19/09/2019.
//  Copyright © 2019 김제현. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa
import RxOptional
import RxSwiftExt

class AlarmRepeatVC: BasePopupVC {
    
    var viewModel: AlarmRepeatVM!
//    init(viewModel: AlarmRepeatVM) {
//        self.viewModel = viewModel
//    }
//
//    required init?(coder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }
    
    deinit {
        
    }
    
    override func initView() {
        self.view.layoutIfNeeded()
        constContainerVertical.constant = self.view.frame.size.height
        
        // 선택된 반복 요일 표시해주기.
        for i in 1 ..< stvContainer.arrangedSubviews.count + 1 {
            let bTag = 100 + i
            let lTag = 300 + i
            let isChecked = self.viewModel.isChecked(tag: i)
            if let button = self.view.viewWithTag(bTag) as? UIButton {
                button.isSelected = isChecked
            }
            
            if let label = self.view.viewWithTag(lTag) as? UILabel {
                label.textColor = self.viewModel.isCheckedColor(checked:isChecked)
            }
        }
    }
    
    override func setBind() {
        for arrView in stvContainer.arrangedSubviews {
            for subView in arrView.subviews {
                if let btn = subView as? UIButton {
                    if btn.tag / 200 == 1 {
                        btn.rx.tap.subscribeOn(MainScheduler.instance)
                            .subscribe(onNext: { [weak self] in
                                if let _self = self {
                                    let bTag = btn.tag % 200 + 100
                                    let lTag = btn.tag % 200 + 300
                                    let isChecked = _self.viewModel.setChecked(tag:bTag)
                                    if let button = _self.view.viewWithTag(bTag) as? UIButton {
                                        button.isSelected = isChecked
                                    }
                                    
                                    if let label = _self.view.viewWithTag(lTag) as? UILabel {
                                        label.textColor = _self.viewModel.isCheckedColor(checked:isChecked)
                                    }
                                }
                            }).disposed(by: disposeBag)
                    }
                }
            }
        }
    }
    
    override func btnCompletePressed(_ sender: UIButton) {
        viewModel.sendCheckedData()
        super.btnCompletePressed(sender)
    }
}
