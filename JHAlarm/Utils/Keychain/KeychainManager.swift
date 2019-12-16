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
        self.keychain = KeychainWrapper.standard
    }
    
    func set<T>(key: String, value: T) throws {
        switch value {
        case is String:
            self.keychain.set(value as! String, forKey: key)
            break
        case is Bool:
            self.keychain.set(value as! Bool, forKey: key)
            break
        case is Data:
            self.keychain.set(value as! Data, forKey: key)
            break
        case is Double:
            self.keychain.set(value as! Double, forKey: key)
            break
        case is Int:
            self.keychain.set(value as! Int, forKey: key)
            break
        case is Float:
            self.keychain.set(value as! Float, forKey: key)
            break
        case is NSCoding:
            self.keychain.set(value as! NSCoding, forKey: key)
            break
        default:
            break
        }
    }
    
    func get<T>(key: String, type: T.Type) throws -> T? {
        if type == String.self {
            return self.keychain.string(forKey: key) as? T
        }
        else if type == Bool.self {
            return self.keychain.bool(forKey: key) as? T
        }
        else if type == Data.self {
            return self.keychain.data(forKey: key) as? T
        }
        else if type == Double.self {
            return self.keychain.double(forKey: key) as? T
        }
        else if type == Int.self {
            return self.keychain.integer(forKey: key) as? T
        }
        else if type == Float.self {
            return self.keychain.float(forKey: key) as? T
        }
        else if type == NSCoding.self {
            return self.keychain.object(forKey: key) as? T
        }
        
        return nil
    }
    
    func remove(key: String) throws {
        self.keychain.removeObject(forKey: key)
    }
}


extension Reactive where Base: KeychainManager {
    func set<T>(key: String, value: T) -> Observable<Void> {
        //        KeychainWrapper.standard.
        return Observable.create { (observer) -> Disposable in
            do {
                try self.base.set(key: key, value: value)
                observer.onCompleted()
            } catch let error {
                observer.onError(error)
            }
            return Disposables.create()
        }
    }
    
    func get<T>(key: String, type: T.Type) -> Observable<T?> {
        return Observable.create { (observer) -> Disposable in
            do {
                let value = try self.base.get(key: key, type: type)
                observer.onNext(value)
                observer.onCompleted()
            } catch let error {
                observer.onError(error)
            }
            return Disposables.create()
        }
    }
    
    func remove(key: String) -> Observable<Void> {
        return Observable.create { (observer) -> Disposable in
            do {
                try self.base.remove(key: key)
                observer.onCompleted()
            } catch let error {
                observer.onError(error)
            }
            return Disposables.create()
        }
    }
}
