//
//  NotificationManager.swift
//  JHAlarm
//
//  Created by Mephrine on 14/10/2019.
//  Copyright © 2019 김제현. All rights reserved.
//

import Foundation
import RxCocoa
import RxSwift

enum NotificationManager: String{
    case reloadColor
    
    var name: Notification.Name {
        return Notification.Name(rawValue)
    }
}

extension NotificationManager {
    func post(object: AnyObject? = nil, userInfo: [NSObject: AnyObject]? = nil) {
        NotificationCenter.default.post(name: name, object: object, userInfo: userInfo)
    }
    
    struct Reactive {
        fileprivate let base: NotificationManager
        
        init (_ base: NotificationManager) {
            self.base = base
        }
    }
    
    var rx: Reactive {
        return Reactive(self)
    }
}

extension NotificationManager.Reactive {
    var post: Observable<Notification> {
        return NotificationCenter.default.rx.notification(base.name)
    }
}
