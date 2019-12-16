//
//  AppDelegate.swift
//  JHAlarm
//
//  Created by 김제현 on 12/08/2019.
//  Copyright © 2019 김제현. All rights reserved.
//

import UIKit
import RxFlow
import RxSwift
import AVFoundation
import AudioToolbox
import UserNotifications
import RealmSwift
import SwiftyUserDefaults

//struct AppServices: HasAppService, HasAlarmService {
//    let AppService: AppService
//    let alarmService: AlarmService
//}


@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, AVAudioPlayerDelegate, UNUserNotificationCenterDelegate {
    //class AppDelegate: UIResponder, UIApplicationDelegate, AVAudioPlayerDelegate, AlarmApplicationDelegate {
    
    var window: UIWindow?
    let disposeBag = DisposeBag()
    var coordinator = FlowCoordinator()
    //
    // Audio
    var audioPlayer: AVAudioPlayer?
    //    lazy var AppService = {
    //        return AppService
    //    }
    
    // 메인 네비이동
    let appService = AppService()
    
    let alarmScheduler = Scheduler.shared
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        guard let window = self.window else { return false }
        
        if #available(iOS 13.0, *) {
            self.window?.overrideUserInterfaceStyle = .light
        }
        
        // Coordinator
        let mainFlow = MainFlow(service: appService)
        
        Flows.whenReady(flow1: mainFlow) { root in
            window.rootViewController = root
            window.makeKeyAndVisible()
        }
        
        self.coordinator.coordinate(flow: mainFlow, with: MainStepper())
        
        // Push
        let center = UNUserNotificationCenter.current()
        center.getNotificationSettings { (settings) in
            if settings.authorizationStatus == .notDetermined {
                self.registNotification()
            }
        }
        
        return true
    }
    
    func registNotification() {
        if #available(iOS 10.0, *) {
            // For iOS 10 display notification (sent via APNS)
            let center = UNUserNotificationCenter.current()
            center.delegate = self
            center.requestAuthorization(options: [.alert, .sound]) { granted, error in
                if(granted){                    // 11/13 메인 쓰레드 관련 경고로 수정함
                    //                    DispatchQueue.main.async {
                    //                        self.application?.registerForRemoteNotifications()
                    //                    }
                } else {
                    
                }
                if error != nil {
                    //                    let content = UNMutableNotificationContent()
                    //                    content.badge = 1
                }
            }
        } else {
            //            let settings: UNNotificationSettings =
            //                UIUserNotificationSettings(types: [.alert, .badge, .sound], categories: nil)
            //
            //            DispatchQueue.main.async {
            //                self.application?.registerUserNotificationSettings(settings)
            //            }
        }
    }
    
    @available(iOS 10.0, *)
    // 백그라운드에서 알림 받았을 경우, 알림을 누르지 않으면 해당 함수 안 탐.
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable: Any],
                     fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        // foreground임으로 alert 띄우기. -> VC로 바꿔야 함. 우선 test
        let storageController = UIAlertController(title: "알람 시간이 되었어요!", message: nil, preferredStyle: .alert)
        //        if let alarmModel = userInfo[ID_ALARM_MODEL] as? AlarmModel {
        let snoozeTime = userInfo[ID_NOTI_ALARM_SNOOZE_TIME] as? Int ?? 0
        let soundName = #"\#(userInfo[ID_NOTI_ALARM_SOUND_NAME] as? String ?? "").mp3"#
        let weekdays = userInfo[ID_NOTI_ALARM_WEEKDAYS] as? [Int] ?? []
        let onSnooze = userInfo[ID_NOTI_ALARM_ONSNOOZE] as? Bool ?? false
        let alarmID = userInfo[ID_NOTI_ALARMID] as? String ?? ""
        let vibration = userInfo[ID_NOTI_VIBRATION] as? Bool ?? false
        
        
        self.playSound(soundName, vibration)
        // 다시알림 체크.
        if snoozeTime > 0 {
            let snoozeOption = UIAlertAction(title: "다시 알림", style: .default) {
                (action:UIAlertAction)->Void in self.audioPlayer?.stop()
                
                self.alarmScheduler.setNotificationForSnooze(snooze: snoozeTime, soundName: soundName, weekdays: weekdays, onSnooze: onSnooze, alarmID: alarmID, vibrartion: vibration)
            }
            storageController.addAction(snoozeOption)
        }
        let stopOption = UIAlertAction(title: "OK", style: .default) {
            (action:UIAlertAction)->Void in
            self.audioPlayer?.stop()
            AudioServicesRemoveSystemSoundCompletion(kSystemSoundID_Vibrate)
            
            // onSnooze false로 변경하기.
            let db = RealmManager.shared.chkRealm()
            //alarmID
            if let alarmModel = Array(RealmManager.shared.select(sortKey: "alarmID", isAscending: true)).first {
                do {
                    try db.write {
                        alarmModel.onSnooze = false
                    }
                } catch {
                    log.e("realm input error")
                }
            }
        }
        
        storageController.addAction(stopOption)
        window?.visibleViewController?.navigationController?.present(storageController, animated: true, completion: nil)
        //        }
    }
    
    
    // 종료된 상태나 Background 상태
    public func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        // foreground임으로 alert 띄우기. -> VC로 바꿔야 함. 우선 test
        let userInfo = response.notification.request.content.userInfo
        //        if let alarmModel = userInfo[ID_ALARM_MODEL] as? AlarmModel {
        let snoozeTime = userInfo[ID_NOTI_ALARM_SNOOZE_TIME] as? Int ?? 0
        let soundName = #"\#(userInfo[ID_NOTI_ALARM_SOUND_NAME] as? String ?? "").mp3"#
        let weekdays = userInfo[ID_NOTI_ALARM_WEEKDAYS] as? [Int] ?? []
        let onSnooze = userInfo[ID_NOTI_ALARM_ONSNOOZE] as? Bool ?? false
        let alarmID = userInfo[ID_NOTI_ALARMID] as? String ?? ""
        let vibration = userInfo[ID_NOTI_VIBRATION] as? Bool ?? false
        
        var playMission = true
        if let alarmModel = Array(RealmManager.shared.select(sortKey: "alarmID", isAscending: true)).filter({ $0.alarmID == alarmID }).first {
            if let mission = alarmModel.mission?.wakeMission {
                if mission != .Base {
                    playMission = true
                    Defaults[.UD_PLAY_MISSION] = alarmID
                } else {
                    playMission = false
                    Defaults[.UD_PLAY_MISSION] = ""
                }
            }
        }
        
        log.d("receive data : \(snoozeTime) | \(soundName) | \(weekdays) | \(onSnooze) | \(alarmID) | \(vibration) | \(playMission)")
        
        if !playMission {
            if let alarmModel = Array(RealmManager.shared.select(sortKey: "alarmID", isAscending: true)).filter({ $0.alarmID == alarmID }).first {
                // onSnooze false로 변경하기.
                let db = RealmManager.shared.chkRealm()
                do {
                    try db.write {
                        alarmModel.onSnooze = false
                    }
                } catch {
                    log.e("realm input error")
                }
                
                let identifier = response.actionIdentifier
                if identifier == ID_SNOOZE_ALARM {
                    alarmScheduler.setNotificationForSnooze(snooze: snoozeTime, soundName: soundName, weekdays: weekdays, onSnooze: onSnooze, alarmID: alarmID, vibrartion: vibration)
                    alarmModel.onSnooze = true
                }
            }
        }
        //        }
    }
    
    // foreground에 있는 상태
    @available(iOS 10.0, *)
    public func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        
        let userInfo = notification.request.content.userInfo
        let storageController = UIAlertController(title: "알람 시간이 되었어요!!!", message: nil, preferredStyle: .alert)
        
        let snoozeTime = userInfo[ID_NOTI_ALARM_SNOOZE_TIME] as? Int ?? 0
        let soundName = #"\#(userInfo[ID_NOTI_ALARM_SOUND_NAME] as? String ?? "").mp3"#
        let weekdays = userInfo[ID_NOTI_ALARM_WEEKDAYS] as? [Int] ?? []
        let onSnooze = userInfo[ID_NOTI_ALARM_ONSNOOZE] as? Bool ?? false
        let alarmID = userInfo[ID_NOTI_ALARMID] as? String ?? ""
        let vibration = userInfo[ID_NOTI_VIBRATION] as? Bool ?? true
        
        var playMission = true
        if let alarmModel = Array(RealmManager.shared.select(sortKey: "alarmID", isAscending: true)).filter({ $0.alarmID == alarmID }).first {
            if let mission = alarmModel.mission?.wakeMission {
                if mission != .Base {
                    playMission = true
                } else {
                    playMission = false
                }
            }
            log.d("receive data1 : \(snoozeTime) | \(soundName) | \(weekdays) | \(onSnooze) | \(alarmID) | \(vibration) | \(playMission) | \(alarmModel)")
        }
        
        log.d("receive data2 : \(snoozeTime) | \(soundName) | \(weekdays) | \(onSnooze) | \(alarmID) | \(vibration) | \(playMission)")
        
        self.playSound(soundName, vibration)
        // 다시알림 체크.
        if playMission {
            let viewModel = AlarmMissionPlayVM(alarmID: alarmID)
            let missionPlayVC = AlarmMissionPlayVC.instantiate(withViewModel: viewModel, storyBoardName: "Main")
            if let root = UIApplication.shared.windows.first!.rootViewController {
                root.present(missionPlayVC, animated: true)
            }
        } else {
            if snoozeTime > 0 {
                let snoozeOption = UIAlertAction(title: "다시 알림", style: .default) {
                    (action:UIAlertAction)->Void in
                    self.audioPlayer?.stop()
                    self.alarmScheduler.setNotificationForSnooze(snooze: snoozeTime, soundName: soundName, weekdays: weekdays, onSnooze: onSnooze, alarmID: alarmID, vibrartion: vibration)
                }
                storageController.addAction(snoozeOption)
            }
            let stopOption = UIAlertAction(title: "OK", style: .default) {
                (action:UIAlertAction)->Void in
                
                self.audioPlayer?.stop()
                AudioServicesRemoveSystemSoundCompletion(kSystemSoundID_Vibrate)
                
                if let alarmModel = Array(RealmManager.shared.select(sortKey: "alarmID", isAscending: true)).first {
                    // onSnooze false로 변경하기.
                    let db = RealmManager.shared.chkRealm()
                    do {
                        try db.write {
                            alarmModel.onSnooze = false
                        }
                    } catch {
                        log.e("realm input error")
                    }
                }
                
                
                
                // change UI -> ViewController 띄울 거 적용.
                //                var mainVC = self.window?.visibleViewController as? MainAlarmViewController
                //                if mainVC == nil {
                //                    let storyboard = UIStoryboard(name: "Main", bundle: nil)
                //                    mainVC = storyboard.instantiateViewController(withIdentifier: "Alarm") as? MainAlarmViewController
                //                }
                //                mainVC!.changeSwitchButtonState(index: index)
            }
            storageController.addAction(stopOption)
            window?.visibleViewController?.navigationController?.present(storageController, animated: true, completion: nil)
        }
        
        completionHandler([.alert, .sound])
    }
    
    func stopAlarm() {
        self.audioPlayer?.stop()
        AudioServicesRemoveSystemSoundCompletion(kSystemSoundID_Vibrate)
        
        if let alarmModel = Array(RealmManager.shared.select(sortKey: "alarmID", isAscending: true)).first {
            // onSnooze false로 변경하기.
            let db = RealmManager.shared.chkRealm()
            do {
                try db.write {
                    alarmModel.onSnooze = false
                }
            } catch {
                log.e("realm input error")
            }
        }
    }
    
    //print out all registed NSNotification for debug
    @available(iOS 10.0, *)
    public func userNotificationCenter(_ center: UNUserNotificationCenter, openSettingsFor notification: UNNotification?) {
        log.d("notification : \(center) | \(notification)")
    }
    
    func setAudioSession() {
        // AVAudio
        var error: NSError?
        do {
            try AVAudioSession.sharedInstance().setCategory(AVAudioSession.Category.playback)
        } catch let error1 as NSError{
            error = error1
            print("could not set session. err:\(error!.localizedDescription)")
        }
        do {
            try AVAudioSession.sharedInstance().setActive(true)
        } catch let error1 as NSError{
            error = error1
            print("could not active session. err:\(error!.localizedDescription)")
        }
    }
    
    //AlarmApplicationDelegate protocol
    func playSound(_ soundName: String, _ vibration: Bool) {
        
        if vibration {
            //vibrate phone first
            AudioServicesPlaySystemSound(SystemSoundID(kSystemSoundID_Vibrate))
            //set vibrate callback
            AudioServicesAddSystemSoundCompletion(SystemSoundID(kSystemSoundID_Vibrate),nil,
                                                  nil,
                                                  { (_:SystemSoundID, _:UnsafeMutableRawPointer?) -> Void in
                                                    AudioServicesPlaySystemSound(SystemSoundID(kSystemSoundID_Vibrate))
            },
                                                  nil)
        }
        if let bundle = Bundle.main.path(forResource: soundName, ofType: "mp3") {
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
                audioPlayer!.delegate = self
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
                player.delegate = nil
                audioPlayer = nil
            }
        }
    }
    
    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
        
        //        UNUserNotificationCenter.current().getNotificationSettings { settings in
        //                            if settings.authorizationStatus == UNAuthorizationStatus.authorized {
        //                                let nContent = UNMutableNotificationContent()
        //                                nContent.title = "JHAlarm을 켜주세요"
        //                                nContent.body = "앱을 꺼두시면 알람이 제대로 울리지 않을 수 있습니다."
        //
        //                                let trigger = UNTimeIntervalNotificationTrigger.init(timeInterval: 5, repeats: false)
        //                                let request = UNNotificationRequest.init(identifier: ID_WAKEUP_NOTI, content: nContent, trigger: trigger)
        //                                UNUserNotificationCenter.current().add(request)
        //                            }
        //                        }
        //    }
    }
    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }
    
    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }
    
    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
        //        Async.main {
        //            self.alarmScheduler.checkNotification()
        //        }
    }
    
    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
        UNUserNotificationCenter.current().getNotificationSettings { settings in
            if settings.authorizationStatus == UNAuthorizationStatus.authorized {
                let nContent = UNMutableNotificationContent()
                nContent.title = "JHAlarm을 켜주세요"
                nContent.body = "앱을 꺼두시면 알람이 제대로 울리지 않을 수 있습니다."
                
                let trigger = UNTimeIntervalNotificationTrigger.init(timeInterval: 5, repeats: false)
                let request = UNNotificationRequest.init(identifier: ID_WAKEUP_NOTI, content: nContent, trigger: trigger)
                UNUserNotificationCenter.current().add(request)
            }
        }
    }
}
//
//@available(iOS 10, *)
//extension AppDelegate : UNUserNotificationCenterDelegate {
//    
//    // Receive displayed notifications for iOS 10 devices.
//    func userNotificationCenter(_ center: UNUserNotificationCenter,
//                                willPresent notification: UNNotification,
//                                withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
//        let userInfo = notification.request.content.userInfo
//        
//        // With swizzling disabled you must let Messaging know about the message, for Analytics
//        Messaging.messaging().appDidReceiveMessage(userInfo)
//        
//        // Print message ID.
//        if let messageID = userInfo[fcmMessageIDKey] {
//            p("Message ID: \(messageID)")
//        }
//        
//        sendNotification(userInfo)
//        
//        // Change this to your preferred presentation option
//        completionHandler([])
//    }
//    
//    func userNotificationCenter(_ center: UNUserNotificationCenter,
//                                didReceive response: UNNotificationResponse,
//                                withCompletionHandler completionHandler: @escaping () -> Void) {
//        let userInfo = response.notification.request.content.userInfo
//        // Print message ID.
//        if let messageID = userInfo[fcmMessageIDKey] {
//            p("Message ID: \(messageID)")
//        }
//        p("userNotificationCenter didReceive : \(userInfo)")
//        
//        sendNotification(userInfo)
//        
//
//        
//        completionHandler()
//    }
//    
//}
