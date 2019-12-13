//
//  RealmManager.swift
//  JHAlarm
//
//  Created by 김제현 on 06/09/2019.
//  Copyright © 2019 김제현. All rights reserved.
//

import Foundation
import RealmSwift
import RxSwift
import RxRealm
import UIKit


class RealmManager: NSObject {
    var realm: Realm?
    
    private func chkRealm() -> Realm? {
        if realm == nil {
            realm = try? Realm()
        }
        return realm
    }
    
    // Realm에서 데이터 조회해오기
    func readData<T>(modelType: T.Type, sortKey: String? = nil, isAscending: Bool = true) -> Results<T>? {
        if let db = chkRealm() {
            if let mType = modelType as? Object.Type {
                if let key = sortKey {
                    return (db.objects(mType) as? Results<T>)?.sorted(byKeyPath: key, ascending: isAscending)
                } else {    
                    return db.objects(mType) as? Results<T>
                }
            }
        }
        return nil
    }
    
    func inputData(data: AlarmModel) {
        if let db = chkRealm() {
            do {
                try db.write {
                    db.add(data)
                }
            } catch {
                p("realm input error")
            }
        }
    }
    
    func deleteData(data: AlarmModel) {
        if let db = chkRealm() {
            do {
                try db.write {
                    db.delete(data)
                }
            } catch {
                p("realm delete error")
            }
        }
    }
    
//    func updateData(data: AlarmModel) {
//        if let db = chkRealm() {
//            do {
//                try db.write {
//
//                }
//            } catch {
//                p("realm update error")
//            }
//        }
//    }
}
