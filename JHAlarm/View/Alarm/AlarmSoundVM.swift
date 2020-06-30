//
//  AlarmSoundVM.swift
//  JHAlarm
//
//  Created by Mephrine on 16/10/2019.
//  Copyright © 2019 김제현. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa
import Differentiator
import RxFlow
import AVKit

struct SoundSection {
    var category: String
    var items: [Item]
}

extension SoundSection: SectionModelType {
    typealias Item = AlarmSound
    
    var identity: String {
        return category
    }
    
    init(original: SoundSection, items: [Item]) {
        self = original
        self.items = items
    }
}

class AlarmSoundVM: BaseVM {
    // Input
    var selectedSound: BehaviorSubject<AlarmSound>      // 테이블내 사운드 선택
    
    // return Value
    let task: PublishSubject<AlarmSound>?
    
    // Output
    var soundData: Observable<[SoundSection]>  {   // 사운드 목록
        return self.getSoundData()
    }
    
    // Base Data
    let categoryCases = AlarmCategory.allCases
    let alarmSoundCases = AlarmSound.allCases
    
    var audioPlayer: AVAudioPlayer?
    
    //OutPut
    init(_ initSound: AlarmSound, task: PublishSubject<AlarmSound>) {
        self.selectedSound = BehaviorSubject<AlarmSound>(value: initSound)
        self.task = task
    }
    
    func selectSound(element: AlarmSound) {
        self.selectedSound.onNext(element)
        self.playSound(soundNm: element.getFileName())
    }
    
    func playSound(soundNm: String) {
        log.d("soundNm : \(soundNm)")
//        if let appDelegate = UIApplication.shared.delegate as? AppDelegate {
//            appDelegate.playSound(soundNm)
//        }
        
        if let bundle = Bundle.main.path(forResource: soundNm, ofType: "mp3") {
            let url = URL(fileURLWithPath: bundle)
            var error: NSError?
            
            do {
                audioPlayer = try AVAudioPlayer(contentsOf: url)
            } catch let error1 as NSError {
                error = error1
                audioPlayer = nil
            }
            
            if let err = error {
                print("audioPlayer error \(err.localizedDescription)")
                return
            } else {
//                audioPlayer!.delegate = self
                audioPlayer!.prepareToPlay()
            }
            
            //negative number means loop infinity
            audioPlayer!.numberOfLoops = -1
            audioPlayer!.play()
        }
    }
    
    func stopSound() {
        if let player = audioPlayer {
            if player.isPlaying {
                player.stop()
                audioPlayer = nil
            }
        }
    }
    
    func getSoundData() -> Observable<[SoundSection]> {
        var data = [SoundSection]()
        for ctgCase in categoryCases {
            let items = alarmSoundCases.filter {
                $0.getFileName().getArrayAfterRegex(regex: "[a-zA-Zㄱ-ㅎㅏ-ㅣ가-힣]").joined() == ctgCase.rawValue
            }
            data.append(SoundSection.init(category: ctgCase.getName(), items: items))
        }
        
        return Observable.just(data)
    }
    
    func isSelectedItem(item: AlarmSound) -> Bool {
        do {
            let selectedItem = try self.selectedSound.value()
            return item == selectedItem
        } catch { }
        return false
    }
    
    // MARK: MOVE
    func dismiss() {
        self.steps.accept(AppStep.closeAlarmSound)
    }
    
    func selectSound() {
        do {
            let selectedItem = try selectedSound.value()
            self.steps.accept(AppStep.closeAlarmSound)
            
            self.task?.onNext(selectedItem)
        } catch let e {
            log.e("select sound error : \(e.localizedDescription)")
        }
    }
    
}

