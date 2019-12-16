//
//  AlarmReRingVC.swift
//  JHAlarm
//
//  Created by Mephrine on 16/10/2019.
//  Copyright © 2019 김제현. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa
import RxOptional
import RxSwiftExt

class AlarmReRingVC: BasePopupVC {
    var viewModel: AlarmReRingVM!
    var ivCheckArray = [UIImageView]()
    
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
        let checkedIvTag = viewModel.isCheckedTag() + 300
        for i in 0 ..< stvContainer.arrangedSubviews.count {
            let iTag = 300 + i
            if let imgView = self.view.viewWithTag(iTag) as? UIImageView {
                if checkedIvTag == iTag {
                    imgView.image = UIImage(named: "chk_on")
                } else {
                    imgView.image = nil
                }
                ivCheckArray.append(imgView)
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
                                    let tag = btn.tag % 200
                                    _self.viewModel.setChecked(tag: tag)
                                    _self.setCheck(tag: tag)
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
    
    func setCheck(tag: Int) {
        for iv in ivCheckArray {
            if iv.tag == (tag + 300) {
                iv.image = UIImage(named: "chk_on")
            } else {
                iv.image = nil
            }
        }
    }
}

