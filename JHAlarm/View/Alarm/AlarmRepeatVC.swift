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

protocol AlarmRepeatDelegate: AnyObject {
    func checkedWeek(checked: [Int])
}

class AlarmRepeatVC: BaseVC {
    @IBOutlet weak var vDim: UIView!
    @IBOutlet weak var vContainer: UIView!
    @IBOutlet weak var stvWeek: UIStackView!
    @IBOutlet weak var constContainerVertical: NSLayoutConstraint!
    
    var viewModel: AlarmRepeatVM?
    weak var delegate: AlarmRepeatDelegate?
        
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
    }
    
    override func setBind() {
        if let vm = self.viewModel {
            for arrView in stvWeek.arrangedSubviews {
                for subView in arrView.subviews {
                    if let btn = subView as? UIButton {
                        if btn.tag % 200 == 0 {
                            btn.rx.tap.subscribeOn(MainScheduler.instance)
                                .subscribe(onNext: { [weak self] in
                                    if let _self = self {
                                        let vTag = btn.tag % 100
                                        if let button = _self.view.viewWithTag(vTag) as? UIButton {
                                            button.isSelected = vm.isChecked(tag:vTag)
                                        }
                                    }
                                })
                        }
                    }
                }
            }
        }
    }
    
    
    func showAnim(_ completeion: @escaping ()->()) {
        constContainerVertical.constant = 0
        UIView.animate(withDuration: 0.3, animations: { [weak self] in
            if let _self = self {
                _self.vDim.alpha = 1.0
                _self.view.layoutIfNeeded()
            }
        }) { (complete) in
            completeion()
        }
    }
    
    func hideAnim() {
        constContainerVertical.constant = self.view.frame.size.height
        UIView.animate(withDuration: 0.3, animations: { [weak self] in
            if let _self = self {
                _self.vDim.alpha = 0.0
                _self.view.layoutIfNeeded()
            }
        })
    }
}

extension AlarmRepeatVC {
    @IBAction func btnCancelPressed(_ sender: UIButton) {
        self.hideAnim()
    }
    
    @IBAction func btnCompletePressed(_ sender: UIButton) {
        if let vm = viewModel {
            delegate?.checkedWeek(checked: vm.manageCheckWeek)
        }
        self.hideAnim()
    }
}
