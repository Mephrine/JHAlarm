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
    static let shared = RealmManager()
    private var realm: Realm?
    let name = "com.adcapsule.jhkimTest.RealmManager"
    
    func chkRealm() -> Realm {
        if realm == nil {
//            let configuration = Realm.Configuration()
            realm = try! Realm()
        }
        return realm!
    }
       
    // Realm에서 데이터 조회해오기
//    func select<T>(modelType: T.Type, sortKey: String? = nil, isAscending: Bool = true) -> Results<T> {
//        if let db = chkRealm() {
//            if let mType = modelType as? Object.Type {
//                if let key = sortKey {
//                    return (db.objects(mType) as! Results<T>).sorted(byKeyPath: key, ascending: isAscending)
//                } else {
//                    return db.objects(mType) as! Results<T>
//                }
//            }
//        }
//    }
    
    // Realm에서 데이터 조회해오기
    func select<T: AlarmModel>(sortKey: String? = nil, isAscending: Bool = true) -> Results<T> {
        let db = chkRealm()
        
        if let key = sortKey {
            return db.objects(T.self).sorted(byKeyPath: key, ascending: isAscending)
        } else {
            return db.objects(T.self)
        }
    }
    
    func insert(data: Object) {
        let db = chkRealm()
        do {
                try db.write {
                    db.add(data)
                }
            } catch {
                log.e("realm input error")
            }
        
    }
    
//    func update(data: Object) {
//        if let db = chkRealm() {
//            do {
//                try db.write {
//                    data
//                }
//            } catch {
//                p("realm input error")
//            }
//        }
//    }
    
    func delete(data: Object) {
      let db = chkRealm()
            do {
                try db.write {
                    db.delete(data)
                }
            } catch {
                log.e("realm delete error")
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
