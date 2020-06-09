//
//  AlarmVM.swift
//  JHAlarm
//
//  Created by 김제현 on 02/09/2019.
//  Copyright © 2019 김제현. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa
import RealmSwift
import RxRealm
import CoreLocation
import SPPermission
import Moya
import Alamofire
import SwiftyJSON
import RxFlow
//import NVActivityIndicatorView

class AlarmVM: Stepper, ViewModelProtocol {
    var steps = PublishRelay<Step>()
    
//    var onShowLoading: Observable {
//
//    }
//    func showIndicator(_ showing: Bool){
//        if showing {
//            let size = CGSize(width: 30, height: 30)
//            startAnimating(size, message: "Loading...", type: NVActivityIndicatorType(rawValue: 29)!)
//        } else {
//            self.stopAnimating()
//        }
//    }
    
   
    
    // MARK: realm
    let manager = RealmManager.shared
    
    func inputData(data: AlarmModel) {
        manager.insert(data: data)
    }
    
    func deleteData(data: AlarmModel) {
        manager.delete(data: data)
    }
    
    //TODO: Mephrine - update도 추가해야함.
    //Realm
    var alarmSchedule: Observable<(AnyRealmCollection<AlarmModel>, RealmChangeset?)>  {
        return Observable.changeset(from: schedule)
    }
    
    var schedule: Results<AlarmModel> {
        return manager.select()
    }
    
//    var alarmSchedule: Observable<[AlarmModel]> {
//        return Observable.of(manager.select().map{ $0 })
//    }
    
    // API Repeat Count
    var getLocCnt = 0
    // DisposeBag
    var disposeBag = DisposeBag()
    
    var weatherData = PublishRelay<Weather>()
    let isLoading = BehaviorRelay<Bool>(value: false)
    
    let reloadData = BehaviorRelay<Bool>(value: false)
    
    var isEditing = BehaviorRelay<Bool>(value: false)
    
    init() {
           self.requestGetWeather()
       }
    
    struct Input {
        
    }
    
    struct Output {
    
    }
    
    
    func transform(input: Input?) -> Output {
        
    }
    
    
    //MARK: LOCATION PERMISSION
    func getLocation() -> Observable<[String: String]?> {
        return Observable.create {[unowned self] (observer) -> Disposable in
            if SPPermission.isAllowed(.locationWhenInUse) || SPPermission.isAllowed(.locationAlwaysAndWhenInUse) {
                observer.onNext(self.getLocationInfo())
                observer.onCompleted()
            } else {
                SPPermission.request(.locationWhenInUse) {[unowned self] in
                    if SPPermission.isAllowed(.locationWhenInUse) {
                        observer.onNext(self.getLocationInfo())
                        observer.onCompleted()
                    } else {
                        observer.onNext(nil)
                        observer.onCompleted()
                    }
                }
            }
            return Disposables.create()
        }
    }
    
    //        func getLocation(_ completion: @escaping ([String: String]?)->()) {
    //            if SPPermission.isAllowed(.locationWhenInUse) || SPPermission.isAllowed(.locationAlwaysAndWhenInUse) {
    //                completion(getLocationInfo())
    //            } else {
    //                SPPermission.request(.locationWhenInUse) {[weak self] in
    //                    if SPPermission.isAllowed(.locationWhenInUse) {
    //                        if let _self = self {
    //                            completion(_self.getLocationInfo())
    //                        }
    //                    } else {
    //                        completion(nil)
    //                    }
    //
    //                }
    //            }
    //        }
    
    func getLocationInfo() -> [String: String]? {
        if getLocCnt < 3 {
            let locationManager = CLLocationManager()
            if locationManager.location == nil {
                getLocCnt += 1
                return getLocationInfo()
            }
            
            print("locationManager.location : \(locationManager.location)")
            print("locationManager. coor : \(locationManager.location?.coordinate)")
            if let manager = locationManager.location?.coordinate {
                let latitude = String(manager.latitude)
                let longitude = String(manager.longitude)
                
                getLocCnt = 0
                return ["lat":latitude, "lon": longitude]
            }
        }
        return nil
    }
    
    
    func requestGetWeather() {
        //ConcurrentDispatchQueueScheduler(globalConcurrentQueueQOS: .Default)
        let backgroundScheduler = ConcurrentDispatchQueueScheduler.init(qos: .background)
        
        getLocation()
            .subscribeOn(MainScheduler.instance)
            .do(onNext: {[unowned self] data in
                self.isLoading.accept(true)
            })
            .observeOn(backgroundScheduler)
            .subscribe(onNext: {[unowned self] (data) in
                if let location = data {
                    let lat:String = location["lat"] ?? "0"
                    let lon:String = location["lon"] ?? "0"
                    print("location : lat : \(lat) | lon : \(lon)")
                    let test = callProvider.rx.request(.GetWeather(lat: lat, lon: lon))
                    
                    test.subscribe {[unowned self] event in
                        switch event {
                        case let .success(response):
                            do {
                                let json = try JSON(data:response.data)
                                if let data = Weather.init(jsonData: json) {
                                    self.weatherData.accept(data)
                                }
                            } catch {
                                print("parsing error")
                            }
                            self.isLoading.accept(false)
                            break
                        case let .error(error):
                            print("network error : \(error)")
                            self.isLoading.accept(false)
                            break
                        }
                    } .disposed(by: self.disposeBag)
                } else {
                    CommonAlert.showAlertType1(title: "", message: "위치 동의를 해주셔야 날씨 정보를 받아올 수 있습니다.")
                }
            }).disposed(by: disposeBag)
    }
    
    
    func requestWeather(_ data: [String :String]?) -> Single<Response> {
        let lat:String = data?["lat"] ?? "0"
        let lon:String = data?["lon"] ?? "0"
        
        return callProvider.rx.request(.GetWeather(lat: lat, lon: lon))
            
//            .subscribe {[unowned self] event in
//            switch event {
//            case let .success(response):
//                do {
//                    let json = try JSON(data:response.data)
//                    if let data = Weather.init(jsonData: json) {
//                        self.weatherData.accept(data)
//                    }
//                } catch {
//                    print("parsing error")
//                }
//
//                break
//            case let .error(error):
//                print("network error : \(error)")
//                break
//            }
//        } .disposed(by: self.disposeBag)
    }
    
    // MARK: Move
    func goEditAlarmDetail(model: AlarmModel? = nil) {
        if let existModel = model {
            self.steps.accept(AppStep.selectAlarmEdit(data: existModel))
        } else {
            goNewAlarmDetail()
        }
    }
    
    func goNewAlarmDetail() {
        // reference라서 이렇게 사용하면 될 것으로 예상.
        let task = PublishSubject<Bool>()
        task.map { _ in true }
            .bind(to: self.reloadData)
            .disposed(by: disposeBag)
        
        self.steps.accept(AppStep.clickNewAlarm(task: task))
    }
    
    func deleteRow(index: Int) {
        let alarmModel = schedule[index]
        RealmManager.shared.delete(data: alarmModel)
    }
    
    func deleteModel(model: AlarmModel) {
        RealmManager.shared.delete(data: model)
    }
}
