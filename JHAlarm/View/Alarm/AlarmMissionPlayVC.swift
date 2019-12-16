//
//  AlarmMissionPlayVC.swift
//  JHAlarm
//
//  Created by 김제현 on 2019/12/13.
//  Copyright © 2019 김제현. All rights reserved.
//


import RxSwift
import RxCocoa
import Foundation
import Reusable
import AVFoundation

class AlarmMissionPlayVC: BaseVC, StoryboardBased, ViewModelBased, UITextFieldDelegate  {
    var viewModel: AlarmMissionPlayVM!
    
    @IBOutlet weak var lbQuiz: UILabel!
    @IBOutlet weak var tfAnswer: UITextField! {
        didSet { tfAnswer?.addDoneCancelToolbar(onDone: (target: self, action: #selector(done)))  }
    }
    @IBOutlet weak var vPlayTime: UIView!
    
    var quizTimer: Timer?
    var currentTime: Int = 30
    
    final let MAX_TIME = 30
    
//    var btnDone = UIButton().then {
//        $0.setTitle("Done", for: UIControlState())
//        $0.setTitleColor(UIColor.black, for: UIControlState())
//        $0.frame = CGRect(x: 0, y: 0, width: 106, height: 53)
//        $0.adjustsImageWhenHighlighted = false
//        $0.addTarget(self, action: #selector(done), for: UIControlEvents.touchUpInside)
//    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillShow),
            name: UIResponder.keyboardWillShowNotification,
            object: nil
        )
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillHide),
            name: UIResponder.keyboardWillHideNotification,
            object: nil
        )
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.timerStart()
        tfAnswer.becomeFirstResponder()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }

    override func initView() {
        self.viewModel.setMission()
        self.tfAnswer.delegate = self
       
        self.vPlayTime.snp.makeConstraints {
            if let superView = self.vPlayTime.superview {
                $0.top.left.bottom.equalTo(superView)
                $0.width.equalTo(superView.snp.width).multipliedBy(1.0)
            }
        }
        self.view.layoutIfNeeded()
        
    }
    
    override func setBind() {
        
        Observable.zip(viewModel.num1, viewModel.num2, viewModel.isPlusSymbol, resultSelector: { (num1, num2, isPlusSymbol) in
            
            return "\(num1) \(isPlusSymbol ? "+" : "-") \(num2)"
            
        }).bind(to: self.lbQuiz.rx.text)
            .disposed(by: disposeBag)
    }
    
    deinit {
        timerEnd()
    }
    
    func timerStart() {
        self.tfAnswer.text = ""
        currentTime = MAX_TIME
        quizTimer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(timeGoes), userInfo: nil, repeats: true)
        
        self.vPlayTime.snp.makeConstraints {
            if let superView = self.vPlayTime.superview {
                $0.top.left.bottom.equalTo(superView)
                $0.width.equalTo(superView.snp.width).multipliedBy(1.0)
            }
        }
        self.view.layoutIfNeeded()
//        let percent = CGFloat(currentTime)/CGFloat(MAX_TIME)
        self.vPlayTime.snp.remakeConstraints {
            guard let superView = self.vPlayTime.superview else { return }
            $0.top.left.bottom.equalTo(superView)
            $0.width.equalTo(superView.snp.width).multipliedBy(0)
        }
        
        UIView.animate(withDuration: Double(MAX_TIME)) {
            self.view.layoutIfNeeded()
        }
    }
    
    func timerEnd() {
        if let timer = quizTimer {
            timer.invalidate()
            timer.fire()
            quizTimer = nil
        }
    }
    
    @objc func timeGoes() {
        currentTime -= 1
        if currentTime <= 0 {
            timerEnd()
            failMission()
        }
    }
    
    func failMission() {
        self.viewModel.setMission()
        self.timerStart()
    }
    
    func complete() {
        timerEnd()
        self.dismiss(animated: true)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if self.viewModel.chkQuizAnswer(answer: textField.text ?? "") {
            textField.resignFirstResponder()
            complete()
            return true
        }
        self.tfAnswer.text = ""
        AudioServicesPlayAlertSound(SystemSoundID(kSystemSoundID_Vibrate))
        return false
    }
    
    @objc func done() {
        if self.viewModel.chkQuizAnswer(answer: tfAnswer.text ?? "") {
               tfAnswer.resignFirstResponder()
               complete()
               return
           }
           self.tfAnswer.text = ""
           AudioServicesPlayAlertSound(SystemSoundID(kSystemSoundID_Vibrate))
    }
    
    @objc func keyboardWillShow(_ sender: Notification) {
//        self.view.frame.origin.y = -150
//        DispatchQueue.main.async { () -> Void in
//            self.btnDone.isHidden = false
//            let keyBoardWindow = UIApplication.shared.windows.last
//            self.btnDone.frame = CGRect(x: 0, y: (keyBoardWindow?.frame.size.height)!-53, width: 106, height: 53)
//            keyBoardWindow?.addSubview(self.btnDone)
//            keyBoardWindow?.bringSubviewToFront(self.btnDone)
//            UIView.animate(withDuration: (((sender.userInfo! as NSDictionary).object(forKey: UIResponder.keyboardAnimationCurveUserInfoKey) as AnyObject).doubleValue)!, delay: 0, options: .curveEaseIn, animations: { () -> Void in
//                self.view.frame = self.view.frame.offsetBy(dx: 0, dy: 0)
//                }, completion: { (complete) -> Void in
//                    print("Complete")
//            })
//        }
    }
    
    
    @objc func keyboardWillHide(_ sender: Notification) {
//        self.view.frame.origin.y = 0
    }
    
//    func textFieldDidBeginEditing(_ textField: UITextField) {
//        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
//    }
}
