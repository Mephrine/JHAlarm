//
//  Scheduler.swift
//  JHAlarm
//
//  Created by Mephrine on 2019/11/28.
//  Copyright © 2019 김제현. All rights reserved.
//

import Foundation
import UIKit
import UserNotifications


//protocol AlarmApplicationDelegate {
//    func playSound(_ soundName: String)
//}
//
//protocol AlarmSchedulerDelegate {
//    func setNotificationWithDate(_ date: Date, onWeekdaysForNotify:[Int], snoozeEnabled: Bool, onSnooze:Bool, soundName: String, index: Int)
//    //helper
//    func setNotificationForSnooze(snoozeMinute: Int, soundName: String, index: Int)
//    func setupNotificationSettings() -> UIUserNotificationSettings
//    func reSchedule()
//    func checkNotification()
//}
//
class Scheduler {
    static let shared = Scheduler()
    
    
    func setupNotificationSettings() {
        var snoozeEnabled: Bool = false
        //         UIApplication.shared.scheduledLocalNotifications
        UNUserNotificationCenter.current().getPendingNotificationRequests {[unowned self] (request) in
            
            if let result = self.minFireDateWithIndex(notifications: request) {
                snoozeEnabled = result.1 > 0 ? true : false
            }
        }
        
        // Specify the notification types.
//        let notificationTypes: UNAuthorizationOptions = [.alert, .sound]
        
        // Specify the notification actions.
        let notificationActionOption = UNNotificationActionOptions()
        
        let stopAction = UNNotificationAction.init(identifier: ID_STOP_ALARM, title: "OK", options: notificationActionOption)
        let snoozeAction = UNNotificationAction.init(identifier: ID_SNOOZE_ALARM, title: "다시알림", options: notificationActionOption)
//        stopAction.identifier = ID_STOP_ALARM
//        stopAction.title = "OK"
//        stopAction.activationMode = UIUserNotificationActivationMode.background
//        stopAction.isDestructive = false
//        stopAction.isAuthenticationRequired = false
        
//        let snoozeAction = UIMutableUserNotificationAction()
//        snoozeAction.identifier = ID_SNOOZE_ALARM
//        snoozeAction.title = "다시알림"
//        snoozeAction.activationMode = UIUserNotificationActivationMode.background
//        snoozeAction.isDestructive = false
//        snoozeAction.isAuthenticationRequired = false
        
        let actionsArray = snoozeEnabled ? [UNNotificationAction](arrayLiteral: snoozeAction, stopAction) : [UNNotificationAction](arrayLiteral: stopAction)
//        let actionsArrayMinimal = snoozeEnabled ? [UNNotificationAction](arrayLiteral: snoozeAction, stopAction) : [UNNotificationAction](arrayLiteral: stopAction)
        
        let notificationCategory = UNNotificationCategory(identifier: ID_ALARM_NOTI, actions: actionsArray, intentIdentifiers: [], options: [])

        
//        for state in notificationStates {
//            for action in state.actions {
//                let notificationAction = UNNotificationAction(identifier: action, title: action, options: [])
//                notificationActions.append(notificationAction)
//            }
//            let muteAction = UNNotificationAction(identifier: "mute", title: "Mute", options: [])
//            let commentAction = UNTextInputNotificationAction(identifier: "inline-comment", title: "Add Comment", options: [], textInputButtonTitle: "Add Comment", textInputPlaceholder: "Comment")
//            notificationCategories.insert(notificationCategory)
//        }
        UNUserNotificationCenter.current().setNotificationCategories([notificationCategory])
        
        
//        // Specify the category related to the above actions.
//        let alarmCategory = UNNotificationCategory()
//        alarmCategory.identifier = ID_ALARM_NOTI
//        alarmCategory.setActions(actionsArray, for: .default)
//        alarmCategory.setActions(actionsArrayMinimal, for: .minimal)
//
//
//        let categoriesForSettings = Set(arrayLiteral: alarmCategory)
//        // Register the notification settings.
//        let newNotificationSettings = UIUserNotificationSettings(types: notificationTypes, categories: categoriesForSettings)
//        UIApplication.shared.registerUserNotificationSettings(newNotificationSettings)

    }
    
    private func correctDate(_ date: Date, onWeekdaysForNotify weekdays:[Int]) -> [Date]
    {
        var correctedDate: [Date] = [Date]()
        let calendar = Calendar.current
        let now = Date().correctSecondComponent()
        let flags: NSCalendar.Unit = [NSCalendar.Unit.weekday, NSCalendar.Unit.weekdayOrdinal, NSCalendar.Unit.day]
        let dateComponents = (calendar as NSCalendar).components(flags, from: date)
        let weekday:Int = dateComponents.weekday!
        
        log.d("correctedDate : \(now) | \(date)")
        //no repeat
        if weekdays.isEmpty{
            //scheduling date is eariler than current date
            if date < now {
                //plus one day, otherwise the notification will be fired righton
                correctedDate.append((calendar as NSCalendar).date(byAdding: NSCalendar.Unit.day, value: 1, to: date, options:.matchStrictly)!)
            }
            else { //later
                correctedDate.append(date)
            }
            return correctedDate
        }
            //repeat
        else {
            let daysInWeek = 7
            correctedDate.removeAll(keepingCapacity: true)
            for wd in weekdays {
                
                var wdDate: Date!
                //schedule on next week
                if compare(weekday: wd, with: weekday) == .before {
                    wdDate =  (calendar as NSCalendar).date(byAdding: NSCalendar.Unit.day, value: wd+daysInWeek-weekday, to: date, options:.matchStrictly)!
                }
                    //schedule on today or next week
                else if compare(weekday: wd, with: weekday) == .same {
                    //scheduling date is eariler than current date, then schedule on next week
                    if date.compare(now) == ComparisonResult.orderedAscending {
                        wdDate = (calendar as NSCalendar).date(byAdding: NSCalendar.Unit.day, value: daysInWeek, to: date, options:.matchStrictly)!
                    }
                    else { //later
                        wdDate = date
                    }
                }
                    //schedule on next days of this week
                else { //after
                    wdDate =  (calendar as NSCalendar).date(byAdding: NSCalendar.Unit.day, value: wd-weekday, to: date, options:.matchStrictly)!
                }
                
                //fix second component to 0
                wdDate = wdDate.correctSecondComponent(calendar: calendar)
                correctedDate.append(wdDate)
            }
            return correctedDate
        }
    }
    
//    public static func correctSecondComponent(date: Date, calendar: Calendar = Calendar(identifier: Calendar.Identifier.gregorian))->Date {
//        let second = calendar.component(.second, from: date)
//        let d = (calendar as NSCalendar).date(byAdding: NSCalendar.Unit.second, value: -second, to: date, options:.matchStrictly)!
//        return d
//    }
    
    
    internal func setNotificationWithDate(date: Date, soundName: String, weekdays: [Int], onSnooze: Bool, snoozeTime: Int, alarmID: String, vibrartion: Bool) {
        let content: UNMutableNotificationContent = UNMutableNotificationContent()
        content.title = "알람!!"
//        content.subtitle = "알람 시간이 됐어요!!!"
        content.body = "일어날 시간이 되었어요!!"
        if !soundName.isEmpty {
            content.sound = UNNotificationSound(named: UNNotificationSoundName(rawValue: "\(soundName).mp3"))
        }
        content.categoryIdentifier = ID_ALARM_NOTI
        content.userInfo = [ID_NOTI_ALARM_SNOOZE_TIME: snoozeTime,
                            ID_NOTI_ALARM_SOUND_NAME: soundName,
                            ID_NOTI_ALARM_WEEKDAYS: weekdays,
                            ID_NOTI_ALARM_ONSNOOZE: onSnooze,
                            ID_NOTI_ALARMID: alarmID,
                            ID_NOTI_VIBRATION: vibrartion]
        
        
        let datesForNotification = correctDate(date.correctSecondComponent(), onWeekdaysForNotify:weekdays)
        
        for day in datesForNotification {
            let flags: NSCalendar.Unit = [NSCalendar.Unit.weekday, NSCalendar.Unit.weekdayOrdinal, NSCalendar.Unit.day, NSCalendar.Unit.hour, NSCalendar.Unit.minute]
            let calendar = Calendar(identifier: Calendar.Identifier.gregorian)
            let dateComponents = (calendar as NSCalendar).components(flags, from: day.correctSecondComponent())
            
            let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: (!weekdays.isEmpty && !onSnooze))
            
            let request = UNNotificationRequest.init(identifier: "\(ID_ALARM_NOTI_REQUEST)_\(day.toString(format: "yyyyMMddHHmm"))_\(weekdays.description)", content: content, trigger: trigger)
            
            
            UNUserNotificationCenter.current().add(request, withCompletionHandler: { (error) in
                if error != nil {
                    //TODO: Handle the error
                }
            })

        }
        setupNotificationSettings()
        
    }
    
    func setNotificationForSnooze(snooze: Int, soundName: String, weekdays: [Int], onSnooze: Bool, alarmID: String, vibrartion: Bool) {
        let calendar = Calendar(identifier: Calendar.Identifier.gregorian)
        let now = Date()
        let snoozeTime = (calendar as NSCalendar).date(byAdding: NSCalendar.Unit.minute, value: snooze, to: now, options:.matchStrictly)!
        setNotificationWithDate(date: snoozeTime, soundName: soundName, weekdays: weekdays, onSnooze: onSnooze, snoozeTime: snooze, alarmID: alarmID, vibrartion: vibrartion)
    }
    
    func reSchedule() {
        //cancel all and register all is often more convenient
        UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
//        UIApplication.shared.cancelAllLocalNotifications()
        
        for model in RealmManager.shared.select() {
            if model.used {
                setNotificationWithDate(date: model.date, soundName: model.soundName.getFileName(), weekdays: Array(model.repetition), onSnooze: model.onSnooze, snoozeTime: model.snoozeTime, alarmID: model.alarmID, vibrartion: model.useVibration)
            }
        }
        
//        let alarmModel = RealmManager.select(AlarmModel)
//        for i in 0..<alarmModel.count{
//            let alarm = alarmModel.alarms[i]
//            if alarm.enabled {
//                setNotificationWithDate(alarm.date as Date, onWeekdaysForNotify: alarm.repeatWeekdays, snoozeEnabled: alarm.snoozeEnabled, onSnooze: false, soundName: alarm.mediaLabel, index: i)
//            }
//        }
    }
    
    // workaround for some situation that alarm model is not setting properly (when app on background or not launched)
    func checkNotification() {
        UNUserNotificationCenter.current().getPendingNotificationRequests { request in
            let db = RealmManager.shared.chkRealm()
            let modelArr = RealmManager.shared.select()
            if request.isEmpty {
                modelArr.forEach { model in
                        do {
                            try db.write {
                                model.onSnooze = false
                            }
                        } catch {
                            log.e("realm input error")
                        }
                }
            } else {
                modelArr.forEach { model in
                    var isOutDated = true
                    if model.onSnooze {
                        isOutDated = false
                    }
                    for noti in request {
                        let trigger = noti.trigger as? UNCalendarNotificationTrigger
                        if let date = trigger?.dateComponents.date {
                            if model.date >= date {
                                isOutDated = false
                            }
                        }
                        
                    }
                    if isOutDated {
                        Async.main {
                            do {
                                try db.write {
                                    model.onSnooze = true
                                }
                            } catch {
                                log.e("realm input error")
                            }
                        }
                    }
                }
            }
        }
        
//        if notifications!.isEmpty {
//            for i in 0..<alarmModel.count {
//                alarmModel.alarms[i].enabled = false
//            }
//        }
//        else {
//            for (i, alarm) in alarmModel.alarms.enumerated() {
//                var isOutDated = true
//                if alarm.onSnooze {
//                    isOutDated = false
//                }
//                for n in notifications! {
//                    if alarm.date >= n.fireDate! {
//                        isOutDated = false
//                    }
//                }
//                if isOutDated {
//                    alarmModel.alarms[i].enabled = false
//                }
//            }
//        }
    }
    
    
    private enum weekdaysComparisonResult {
        case before
        case same
        case after
    }
    
    private func compare(weekday w1: Int, with w2: Int) -> weekdaysComparisonResult
    {
        if w1 != 1 && w2 == 1 {return .before}
        else if w1 == w2 {return .same}
        else {return .after}
    }
    
    private func minFireDateWithIndex(notifications: [UNNotificationRequest]) -> (Date, Int)? {
        if notifications.isEmpty {
            return nil
        }
        
        var snoozeTime = 0
        let trigger = notifications.first?.trigger as? UNCalendarNotificationTrigger
        //        var minDate: Date = notifications.first!.fireDate!
        var minDate = trigger?.dateComponents.date
        if let minDt = trigger?.dateComponents.date {
            
            for noti in notifications {
                let userInfo = noti.content.userInfo
                    let trig = noti.trigger as? UNCalendarNotificationTrigger
                    if let fireDate = trig?.dateComponents.date {
                        let snooze = userInfo[ID_NOTI_ALARM_SNOOZE_TIME] as! Int
                        if(fireDate <= minDt) {
                            minDate = fireDate
                            snoozeTime = snooze
                        }
                    }
            }
            return (minDate, snoozeTime) as? (Date, Int)
        }
        return nil
    }
    
    
    //test
//    func setLocalNotification() {
//        if #available(iOS 10.0, *) {
//            let center = UNUserNotificationCenter.current()
//            let options: UNAuthorizationOptions = [.alert, .sound];
//
//            center.requestAuthorization(options: options) {
//                (granted, error) in
//                if granted {
//                    let content = UNMutableNotificationContent()
//                    content.categoryIdentifier = "awesomeNotification"
//                    content.title = "Notification"
//                    content.body = "Body"
//                    let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 60, repeats: true)
//                    let request = UNNotificationRequest(identifier: "FiveSecond", content: content, trigger: trigger)
//                    let center = UNUserNotificationCenter.current()
//                    center.add(request) { (error) in
//                        print(error?.localizedDescription ?? "")
//                    }
//                }
//            }
//        }
//        else
//        {
//            UIApplication.shared.registerUserNotificationSettings(UIUserNotificationSettings(types: [.badge, .sound, .alert], categories: nil))
//            UIApplication.shared.registerForRemoteNotifications()
//            let notification = UILocalNotification()
//            notification.userInfo = ["indentifier" : "awesomeNotification"]
//            notification.alertTitle = "Notification"
//            notification.alertBody = "Body"
//            notification.fireDate = NSDate(timeIntervalSinceNow:60) as Date
//            notification.repeatInterval = NSCalendar.Unit.minute
//            UIApplication.shared.cancelAllLocalNotifications()
//            UIApplication.shared.scheduledLocalNotifications = [notification]
//        }
//    }
//
//    func cancle() {
//        if #available(iOS 10.0, *) {
//            UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: ["awesomeNotification"])
//        } else {
//            if let notifications = UIApplication.shared.scheduledLocalNotifications {
//                for notification in notifications {
//                    if notification.userInfo?["identifier"] as? String == "awesomeNotification" {
//                        UIApplication.shared.cancelLocalNotification(notification)
//                    }
//                }
//            }
//        }
//    }
//    func repeatTime() {
//        let content = UNMutableNotificationContent()
//        content.title = "Noti Title"
//        content.body = "Noti Body"
//
//        let calendar = Calendar.current
//        var dateComponents = DateComponents()
//        dateComponents.hour = 10
//        dateComponents.minute = 30
//
//        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)
//        let request = UNNotificationRequest(identifier: TRAINING_NOTIFICATION, content: content, trigger: trigger)
//        let center = UNUserNotificationCenter.current()
//        center.add(request) { (error) in
//            print(error?.localizedDescription ?? "")
//        }
//    }
}


