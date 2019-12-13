//
//  AlarmVC.swift
//  JHAlarm
//
//  Created by 김제현 on 02/09/2019.
//  Copyright © 2019 김제현. All rights reserved.
//

import Foundation
import RxCocoa
import RxSwift
import RxRealm
import RealmSwift
import Moya_SwiftyJSONMapper
import Moya
import Kingfisher

class AlarmVC: BaseVC {
    // View
    var tbAlarm: UITableView!
    var vHeaderWeather: HeaderWeatherView?
    @IBOutlet var headerView: HeaderView!
    
    // ViewModel
    let viewModel = AlarmVM()
    
    // Variable
    var previousScrollOffset: CGFloat = 0.0
    
    @IBOutlet var btnPlus: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewModel.requestGetWeather()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }
    
    deinit {
        
    }
    
    // 뷰 초기 작업 관련
    override func initView() {
        // 테이블뷰 만들기.
        tbAlarm = createView(UITableView(), parent: self.view, setting: { (tableView) in
            tableView.rowHeight = UITableView.automaticDimension
            tableView.estimatedRowHeight = 100
            tableView.register(UINib.init(nibName: "AlarmTableCell", bundle: nil), forCellReuseIdentifier: "AlarmTableCell")
            tableView.separatorStyle = .none
            tableView.delegate = self
            tableView.backgroundColor = .clear
            if #available(iOS 11.0, *) {
                tableView.contentInsetAdjustmentBehavior = .never
            }
            
            self.view.bringSubviewToFront(self.btnPlus)
        }, constraint: { [weak self] in
            if let _self = self {
                $0.top.equalTo(_self.headerView.snp.bottom)
                $0.left.bottom.right.equalToSuperview()
            }
        })
        
        vHeaderWeather = UINib.init(nibName: "HeaderWeatherView", bundle: nil).instantiate(withOwner: nil, options: nil).first as? HeaderWeatherView
    }
    
    // 뷰 바인딩하기.
    override func setBind() {
        // cellForItemAt
        
        // 알람 목록 바인딩
        if let data = viewModel.schedules {
            // datasource 작성.
            //        let dataSource = RxTableViewSectionedReloadDataSource<String>.init(configureCell: { (dataSource, tableView, indexPath, item) -> UITableViewCell in
            //            guard let cell = tableView.dequeueReusableCell(withIdentifier: "AlarmTableCell", for: indexPath) as? AlarmTableCell else { return UITableViewCell()}
            //            cell.setData(item)
            //            return cell
            //        })
            //        (
            //            configureCell: { dataSource, tableView, indexPath, item in
            //                guard let cell = tableView.dequeueReusableCell(withIdentifier: "AlarmTableCell", for: indexPath) as? AlarmTableCell else { return UITableViewCell()}
            //                cell.setData(item)
            //                return cell
            //            })
            //viewForFooterInSection
            let objArray = Observable.just(data)
            //            data.rx.obser
            
            objArray.bind(to: tbAlarm.rx.items(cellIdentifier: "AlarmTableCell")) { row, element, cell in
                if let usedCell = cell as? AlarmTableCell {
                    usedCell.configure(element)
                }
                }.disposed(by: disposeBag)
            
            
            //            objArray.bind(to: tbAlarm.rx.items(cellIdentifier: "cell", cellType: UITableViewCell.self)) { (row, element, cell) in
            //                    cell.configure(element)
            //                }.disposed(by: disposeBag)
            
            //            Observable.just(data)
            //                .observeOn(MainScheduler.instance)
            //                .bind(to: tbAlarm.rx.items(cellIdentifier: "AlarmTableCell", cellType: AlarmTableCell.self)) { (row, element, cell) in
            //                    cell.setData(element)
            //                }.disposed(by: disposeBag)
            //
            
            //            Observable.collection(from: data)
            //                .observeOn(MainScheduler.instance)
            //                .bind(to: tbAlarm.rx.items(cellIdentifier: "AlarmTableCell", cellType: AlarmTableCell.self)) { (row, element, cell) in
            //                cell.setData(element)
            //            }.disposed(by: disposeBag)
            
            // FooterView
            tbAlarm.rx.setDelegate(self)
                .disposed(by: disposeBag)
            
            
            /*
             
             tbAlarm.rx.itemSelected
             .asDriver()
             .map{ $0.row }
             .withLatestFrom(data, resultSelector: {
             
             })
             .drive(onNext: { (index) in
             
             }, onCompleted: {
             
             })
             .disposed(by: disposeBag)
             }
             */
            
            tbAlarm.rx.modelSelected(AlarmModel.self)
                .throttle(0.5, scheduler: MainScheduler.instance)
                .subscribe({ (item) in
                    MoveManager.alarmDetailPage(isPush: true, item.element)
                })
                .disposed(by: disposeBag)
            
            //            tbAlarm.rx.itemSelected
            //                .map{ $0.row }
            //                .withLatestFrom(data, resultSelector: {
            //                    $0
            //                })
            //                .drive(onNext: { (index) in
            //                    <#code#>
            //                }, onCompleted: {
            //                    <#code#>
            //                })
            //                .disposed(by: disposeBag)
        }
        
    }
}

extension AlarmVC {
    @IBAction func btnPlusPressed(_ sender: Any) {
        MoveManager.alarmDetailPage(isPush: true)
    }
}

// MARK: - 일반 함수
extension AlarmVC {
    
    
    
}

// MARK: - UITable
extension AlarmVC: UITableViewDelegate {
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        // 헤더뷰 설정.
        if let header = self.vHeaderWeather {
                viewModel.weatherData.subscribe(onNext: { (weatherData) in
                    header.ivWeather.kf.setImage(with: weatherData.weather?.first?.icon)
                    header.lbWeather.text = "\(weatherData.main?.tempMin ?? "")~\(weatherData.main?.tempMax ?? "")"
                    }).disposed(by: disposeBag)
            return header
        }
        
        return nil
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 60
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        if self.viewModel.schedules == nil || self.viewModel.schedules?.count == 0 {
            if let view = Bundle.main.loadNibNamed("NoDataView", owner: nil, options: nil)?.first as? NoDataView {
                return view
            }
        }
        return nil
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        if self.viewModel.schedules == nil || self.viewModel.schedules?.count == 0 {
            return 300
        }
        return 0
    }
}


// MARK: - UIScrollViewDelegate
extension AlarmVC: UIScrollViewDelegate {
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        guard let vc = self.parent as? MainVC else { return }
        if(velocity.y > 0) {
            vc.animHideFooter()
        }else{
            vc.animShowFooter()
        }
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        // 스클롤 이동중 : 헤더 이동
//        self.previousScrollOffset = self.headerView.scrollViewDidScroll(tableView: self.tbAlarm, previousScrollOffset: self.previousScrollOffset)
        
    }
}

//extension PrimitiveSequence where TraitType == SingleTrait, ElementType == Response {
//
//    /// Maps data received from the signal into an object which implements the ALSwiftyJSONAble protocol.
//    /// If the conversion fails, the signal errors.
//    public func map<T: ALSwiftyJSONAble>(to type: T.Type) -> Single<T> {
//        return flatMap { response -> Single<T> in
//            return Single.just(try response.map(to: type))
//        }
//    }
//
//    /// Maps data received from the signal into an array of objects which implement the ALSwiftyJSONAble protocol.
//    /// If the conversion fails, the signal errors.
//    public func map<T: ALSwiftyJSONAble>(to type: [T.Type]) -> Single<[T]> {
//        return flatMap { response -> Single<[T]> in
//            return Single.just(try response.map(to: type))
//        }
//    }
//}
