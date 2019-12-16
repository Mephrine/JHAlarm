//
//  AlarmDetailVC.swift
//  JHAlarm
//
//  Created by 김제현 on 02/09/2019.
//  Copyright © 2019 김제현. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import Reusable

class AlarmDetailVC: BaseVC, StoryboardBased, ViewModelBased {
    // ~후에 울림
    @IBOutlet var lbRingAlarmTime: UILabel!
    @IBOutlet weak var lbSnoozeTime: UILabel!
    @IBOutlet weak var lbSoundNm: UILabel!
    @IBOutlet weak var lbMissionNm: UILabel!
    @IBOutlet weak var tfDesc: UITextField!
    
    // Date피커
    @IBOutlet var pickerDate: UIDatePicker!

    // 요일
    @IBOutlet weak var lbRepeatSelect: UILabel!
    
    // 볼륨
    @IBOutlet weak var sliderVolume: UISlider!
    @IBOutlet var btnVibrate: UIButton!
    
    @IBOutlet weak var constStvBottom: NSLayoutConstraint!
    @IBOutlet weak var constBottomViewH: NSLayoutConstraint!
    
    // 하단 버튼
    @IBOutlet weak var btnCancel: UIButton!
    @IBOutlet weak var btnConfirm: UIButton!
    
    
    // ViewModel
    var viewModel: AlarmDetailVM!
    
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
        
        sliderVolume.minimumValue = 0
        sliderVolume.maximumValue = 100
        sliderVolume.value = viewModel.soundVolume.value
        
        self.btnVibrate.isSelected = self.viewModel.switchVibrate.value
        
        self.view.layoutIfNeeded()
        constStvBottom.constant = safeAreaBottomAnchor
        constBottomViewH.constant = 60 + safeAreaBottomAnchor
        
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
        self.pickerDate.rx.date
            .bind(to: viewModel.alarmDt)
            .disposed(by: disposeBag)
        
        
        Observable.combineLatest(pickerDate.rx.date, viewModel.repeatDay) { [unowned self] in
            
            return self.viewModel.setRingAlarmTime($0, $1)
            }.subscribeOn(MainScheduler.instance)
            .subscribe(onNext: { [weak self] in
                if let _self = self {
                    _self.lbRingAlarmTime.text = $0
                }
            }).disposed(by: disposeBag)
        
        // 미션
        self.viewModel.mission.map { [unowned self] _ in
            self.viewModel.getMissionNmText()
               }.bind(to: lbMissionNm.rx.text)
                   .disposed(by: disposeBag)
        
        // 반복
        self.viewModel.repeatDay.subscribeOn(MainScheduler.instance).subscribe(onNext: { [weak self] data in
            if let _self = self {
                _self.lbRepeatSelect.text = _self.viewModel.getSelectedWeekText()
            }
            }).disposed(by: disposeBag)
        
        
        // 사운드
        self.btnVibrate.rx.tap
            .asDriver(onErrorJustReturn: ())
            .drive(onNext: { [weak self] in
            if let _self = self {
                _self.btnVibrate.isSelected.toggle()
                _self.viewModel.switchVibrate.accept(_self.btnVibrate.isSelected)
            }
            }, onCompleted: {
                
        }) {
            
        }.disposed(by: disposeBag)
        
        
        self.viewModel.soundNm.map { [unowned self] _ in
            self.viewModel.getSoundNmText()
        }.bind(to: lbSoundNm.rx.text)
        .disposed(by: disposeBag)
        
        self.viewModel.switchVibrate.bind(to: self.btnVibrate.rx.isSelected)
            .disposed(by: disposeBag)
        
        self.sliderVolume.rx.value
        .bind(to: viewModel.soundVolume)
        .disposed(by: disposeBag)
        
        // 다시울림
        self.viewModel.snoozeTime.map { [unowned self] _ in
            self.viewModel.getSnoozeTimeText()
        }.bind(to: self.lbSnoozeTime.rx.text)
        .disposed(by: disposeBag)
        
        // 설명
        viewModel.alarmDesc.bind(to: self.tfDesc.rx.text)
        .disposed(by: disposeBag)
        
            
            
//            .subscribe(onNext: { [weak self] data in
//            if let _self = self {
//                _self.lbSnoozeTime.text = _self.viewModel.getSnoozeTimeText()
//            }
//            }).disposed(by: disposeBag)
        
        
        
//        btnVibrate.rx.tap. .map {
//        }.subscribe(onNext: { [weak self] isEnabled in
//
//            }).disposed(by: disposeBag)
        
        //viewModel.repeatDay 날짜 표기도 해야함.
        
        
        
        // 하단 버튼들.
        btnCancel.rx.tap.throttle(0.5, scheduler: MainScheduler.instance) .asDriver(onErrorJustReturn: ())
            .drive ( onNext: { [weak self] in
                self?.viewModel.popViewController()
        }).disposed(by: disposeBag)
        
        btnConfirm.rx.tap
            .asDriver(onErrorJustReturn: ())
            .drive ( onNext: { [weak self] in
                self?.viewModel.saveAlarmAndPop()
        }).disposed(by: disposeBag)
    }

}

extension AlarmDetailVC {
    @IBAction func btnClosePressed(_ sender: Any) {
        self.viewModel.popViewController()
    }
    
    @IBAction func missionPressed(_ sender: Any) {
        self.viewModel.clickChoiceMission()
    }
    
    @IBAction func repeatPressed(_ sender: Any) {
        viewModel.showRepeatView()
            .subscribeOn(MainScheduler.instance)
            .subscribe(onNext: { [weak self] repeatVC in
                if let _self = self {
                    _self.addChild(repeatVC)
                    _self.view.addSubview(repeatVC.view)
                    repeatVC.view.snp.makeConstraints {
                        $0.top.equalTo(_self.view.snp.top)
                        $0.left.equalTo(_self.view.snp.left)
                        $0.right.equalTo(_self.view.snp.right)
                        $0.bottom.equalTo(_self.view.snp.bottom)
                    }
                    _self.view.layoutIfNeeded()
                    
                    repeatVC.showAnim {}
                }
            }).disposed(by: disposeBag)
    }
    
    @IBAction func soundPressed(_ sender: Any) {
        self.viewModel.clickChoiceAlarm()
    }
    
    @IBAction func reRingPressed(_ sender: Any) {
        viewModel.showReRingView()
        .subscribeOn(MainScheduler.instance)
        .subscribe(onNext: { [weak self] popupVC in
            if let _self = self {
                _self.addChild(popupVC)
                _self.view.addSubview(popupVC.view)
                popupVC.view.snp.makeConstraints {
                    $0.top.equalTo(_self.view.snp.top)
                    $0.left.equalTo(_self.view.snp.left)
                    $0.right.equalTo(_self.view.snp.right)
                    $0.bottom.equalTo(_self.view.snp.bottom)
                }
                _self.view.layoutIfNeeded()
                
                popupVC.showAnim {}
            }
        }).disposed(by: disposeBag)
    }
    
    
    @IBAction func descPressed(_ sender: Any) {
        tfDesc.becomeFirstResponder()
    }
}
