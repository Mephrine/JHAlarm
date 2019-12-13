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
import Moya_SwiftyJSONMapper
import Moya
import Alamofire
import SwiftyJSON

class AlarmVM {
    var disposeBag = DisposeBag()
    var getLocCnt = 0
    
    //Realm
    var schedules: Results<AlarmModel>? {
        get {
            return manager.select(modelType: AlarmModel.self)
        }
    }

    var manager = RealmManager()
    
    var weatherData = PublishRelay<Weather>()
    
    // Realm에서 데이터 조회해오기
//    func requestAlarmData() {
//        schedules = manager.readData(modelType: AlarmModel.self)
//        print("Realm : \(Realm.Configuration.defaultConfiguration)")
//        print("object count : \(schedules?.count)")
//        schedules.accept(["A", "B", "C"])

//    }

    
    
    func inputData(data: AlarmModel) {
        manager.insert(data: data)
    }
    
    func deleteData(data: AlarmModel) {
        manager.delete(data: data)
    }
    
    //MARK: LOCATION PERMISSION
    func getLocation(_ completion: @escaping ([String: String]?)->()) {
        if SPPermission.isAllowed(.locationWhenInUse) || SPPermission.isAllowed(.locationAlwaysAndWhenInUse) {
            completion(getLocationInfo())
        } else {
            SPPermission.request(.locationWhenInUse) {[weak self] in
                if SPPermission.isAllowed(.locationWhenInUse) {
                    if let _self = self {
                        completion(_self.getLocationInfo())
                    }
                } else {
                    completion(nil)
                }
                
            }
        }
    }
    
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
    
    //test
    func requestGetWeather() {
        getLocation {[weak self] data in
            if let _self = self {
                if let location = data {
                    let lat:String = location["lat"] ?? "0"
                    let lon:String = location["lon"] ?? "0"
                    print("location : lat : \(lat) | lon : \(lon)")
                    callProvider.rx.request(.GetWeather(lat: lat, lon: lon)).retry(3).debug().subscribe {[weak self] event in
                        if let _self = self {
                            switch event {
                            case let .success(response):
                                do {
                                    let json = try JSON(data:response.data)
                                    if let data = Weather.init(jsonData: json) {
                                        _self.weatherData.accept(data)
                                    }
                                } catch {
                                    print("parsing error")
                                }
                                
                                break
                            case let .error(error):
                                print("network error : \(error)")
                                break
                            }
                        }
                        } .disposed(by: _self.disposeBag)
                }
            }
        }
        
    }
    
    
}
