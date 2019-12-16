//
//  AlarmMissionShakeVC.swift
//  JHAlarm
//
//  Created by Mephrine on 21/11/2019.
//  Copyright © 2019 김제현. All rights reserved.
//

import Foundation
import Reusable
import RxSwift
import RxCocoa

class AlarmMissionShakeVC: BaseVC, StoryboardBased, ViewModelBased  {
    var viewModel: AlarmMissionShakeVM!
    
    @IBOutlet weak var lbQuizeNum: UILabel!
    @IBOutlet weak var pickerMission: UIPickerView!
    @IBOutlet weak var btnComplete: UIButton!

    let pickerData = ["쉬움", "중간", "어려움"]
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
        pickerMission.delegate = self
        pickerMission.dataSource = self
    }
    
    override func setBind() {
        btnComplete.rx.tap.asDriver()
            .throttle(0.3)
            .drive(onNext: { [weak self] in
                guard let _self = self else { return }
                _self.viewModel.setMissionAndDismiss()
            }).disposed(by: disposeBag)
    }
    
    @IBAction func stepper(_ sender: UIStepper) {
        lbQuizeNum.text = "\(Int(sender.value))번 흔들어 주세요"
    }
}

extension AlarmMissionShakeVC: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pickerData.count
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return pickerData[row]
    }
    
}
