//
//  KeychainManager.swift
//  JHAlarm
//
//  Created by Mephrine on 14/10/2019.
//  Copyright © 2019 김제현. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa
import SwiftKeychainWrapper

class KeychainManager: ReactiveCompatible {
    private let keychain: KeychainWrapper
    private init(){
        self.keychain
    }
}


extension Reactive where Base: KeychainManager {
    func set(key: String, value: String) -> Observable<Void> {
//        KeychainWrapper.standard.
        return Observable.create { (observer) -> Disposable in
            do {
                try self.base.
            } catch {
                
            }
        }
    }
    func get(key: String) {
        
    }
}
