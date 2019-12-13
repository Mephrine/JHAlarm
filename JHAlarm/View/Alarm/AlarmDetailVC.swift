//
//  AlarmDetailVC.swift
//  JHAlarm
//
//  Created by 김제현 on 02/09/2019.
//  Copyright © 2019 김제현. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

class AlarmDetailVC: BaseVC {
    // ~후에 울림
    @IBOutlet var lbRingAlarmTime: UILabel!
    
    // Date피커
    @IBOutlet var pickerDate: UIDatePicker!

    // 요일
    
    // 볼륨
    @IBOutlet var btnVibrate: UIButton!
    
    // ViewModel
    var viewModel = AlarmDetailVM(schedule: nil)
    
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
        pickerDate.datePickerMode = .time
        pickerDate.date = viewModel.getInitPickerDt()
    }
    
    override func setBind() {
        // Input
//        pickerDate.rx.date
//            .subscribe {[weak self] in
//                if let _self = self {
//                    _self.viewModel.setRingAlarmTime($0)
//                }
//            }
        
//            .map { [weak self] in
//            if let _self = self {
//                dateFormat.string(from: $0)
//            }
//            }.bind(to: viewModel.ringAlarmTime)
//            .disposed(by: disposeBag)
  
        
        // Output
        
        
        // ?? 후에 알람 울림 -> datePicker와 요일에 따라 해당 데이터가 변경.        
//        Driver.combineLatest(pickerDate.rx.date, viewModel.repeatDay) { [weak self] in
//            self?.viewModel.setRingAlarmTime($0, $1)
//        }
        
        Observable.combineLatest(pickerDate.rx.date, viewModel.repeatDay) { [unowned self] in
            
            return self.viewModel.setRingAlarmTime($0, $1)
            }.subscribeOn(MainScheduler.instance)
            .subscribe(onNext: { [weak self] in
                if let _self = self {
                    _self.lbRingAlarmTime.text = $0
                }
            }).disposed(by: disposeBag)
    }

}

extension AlarmDetailVC {
    @IBAction func btnClosePressed(_ sender: Any) {
        MoveManager.alarmDetailPage(isPush: false)
    }
    
    @IBAction func missionPressed(_ sender: Any) {
        
    }
    
    @IBAction func repeatPressed(_ sender: Any) {
        viewModel.showRepeatView { [weak self] captchaView in
            if let _self = self {
                _self.view.addSubview(captchaView)
                
                captchaView.snp.makeConstraints {
                    $0.top.equalTo(_self.view.snp.top)
                    $0.left.equalTo(_self.view.snp.left)
                    $0.right.equalTo(_self.view.snp.right)
                    $0.bottom.equalTo(_self.view.snp.bottom)
                }
                
                _self.view.layoutIfNeeded()
            }
            
        }
    }
    
    @IBAction func soundPressed(_ sender: Any) {
        
    }
    
    @IBAction func reBellPressed(_ sender: Any) {
        
    }
    
    @IBAction func vibratePressed(_ sender: Any) {
        
    }
    
    @IBAction func descPressed(_ sender: Any) {
        
    }
}
