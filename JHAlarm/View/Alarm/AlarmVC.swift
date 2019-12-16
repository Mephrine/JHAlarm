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
import Moya
import Kingfisher
import RxRealmDataSources

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
    @IBOutlet weak var btnEdit: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
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
        if tbAlarm == nil {
            // 테이블뷰 만들기.
            tbAlarm = UITableView().then { tableView in
                tableView.rowHeight = UITableView.automaticDimension
                tableView.estimatedRowHeight = 100
                tableView.register(UINib.init(nibName: "AlarmTableCell", bundle: nil), forCellReuseIdentifier: "AlarmTableCell")
                tableView.separatorStyle = .none
                tableView.delegate = self
                tableView.backgroundColor = .clear
                tableView.isScrollEnabled = true
                tableView.bounces = true
                tableView.allowsSelectionDuringEditing = true
                
                if #available(iOS 11.0, *) {
                    tableView.contentInsetAdjustmentBehavior = .never
                }
            }
        }
        
        if !Global.findView(superView: self.view, findView: tbAlarm, type: UITableView.self) {
            self.view.addSubview(tbAlarm)
            
            tbAlarm.snp.makeConstraints { [weak self] in
                if let _self = self {
                    $0.top.equalTo(_self.headerView.snp.bottom)
                    $0.left.bottom.right.equalToSuperview()
                }
            }
        }
        
        self.view.bringSubviewToFront(self.btnPlus)
        
//        tbAlarm = createView(UITableView(), parent: self.view, setting: { (tableView) in
//            tableView.rowHeight = UITableView.automaticDimension
//            tableView.estimatedRowHeight = 100
//            tableView.register(UINib.init(nibName: "AlarmTableCell", bundle: nil), forCellReuseIdentifier: "AlarmTableCell")
//            tableView.separatorStyle = .none
////            tableView.delegate = self
//            tableView.backgroundColor = .clear
//            tableView.isScrollEnabled = true
//            tableView.bounces = true
//
//            if #available(iOS 11.0, *) {
//                tableView.contentInsetAdjustmentBehavior = .never
//            }
//
//
//        }, constraint: { [weak self] in
//            if let _self = self {
//                $0.top.equalTo(_self.headerView.snp.bottom)
//                $0.left.bottom.right.equalToSuperview()
//            }
//        })
    }
    /**
     
     */
    
    // 뷰 바인딩하기.
    override func setBind() {
        /// dataSource
        let realmDataSource = RxTableViewRealmDataSource<AlarmModel>.init(cellIdentifier: "AlarmTableCell", cellType: AlarmTableCell.self) { cell, indexPath, item in
            cell.configure(item)
        }
        
        /// Loading
        viewModel.isLoading.subscribe(onNext: { [weak self] isLoading in
            if let _self = self {
                _self.showIndicator(isLoading)
            }
            }).disposed(by: disposeBag)
        
        /// 191206
        viewModel.alarmSchedule
            .bind(to: tbAlarm.rx.realmChanges(realmDataSource))
            .disposed(by: disposeBag)
        
        viewModel.alarmSchedule
            .subscribeOn(Schedulers.main)
            .subscribe(onNext: { [weak self] in
                guard let _self = self else { return }
                let cnt = $0.0.count
                if cnt > 0 {
                    _self.btnEdit.isHidden = false
                    _self.setNoDataView(isShow: false)
                } else {
                    _self.btnEdit.isHidden = true
                    _self.setNoDataView(isShow: true)
                }
               
            }) .disposed(by: disposeBag)
                   
        
        log.d("self.viewModel.alarmSchedule : \(self.viewModel.alarmSchedule.count())")
//        self.viewModel.alarmSchedule.count()
//            .map { $0 > 0 }
//            .bind(to: self.btnEdit.rx.isHidden)
//            .disposed(by: disposeBag)
//
//        self.viewModel.alarmSchedule.count()
//            .map { $0 == 0 }
//            .subscribeOn(Schedulers.main)
//            .subscribe(onNext: { [weak self] in
//                self?.setNoDataView(isShow: $0)
//            })
//        .disposed(by: disposeBag)
        
        
        self.tbAlarm.rx.realmModelSelected(AlarmModel.self)
            .asDriver()
            .drive(onNext : { [weak self] in
                self?.viewModel.goEditAlarmDetail(model: $0)
            })
            .disposed(by: disposeBag)
       
        self.tbAlarm.rx.itemDeleted.asDriver()
            .drive(onNext: { [weak self] indexPath in
                guard let _self = self else { return }
                let index = indexPath.row
                _self.viewModel.deleteRow(index: index)
                // Delete the row from the data source
                _self.tbAlarm.beginUpdates()
                _self.tbAlarm.deleteRows(at: [indexPath], with: .middle)
                _self.tbAlarm.endUpdates()
                Scheduler.shared.reSchedule()
            })
            .disposed(by: disposeBag)
        
                
        self.viewModel.isEditing.asDriver()
        .drive(onNext: { [weak self] in
            guard let _self = self else { return }
            if $0 {
                _self.btnEdit.setTitle("Done", for: .normal)
                _self.tbAlarm.setEditing(true, animated: true)
            } else {
                _self.btnEdit.setTitle("Edit", for: .normal)
                _self.tbAlarm.setEditing(false, animated: true)
            }
        }).disposed(by: disposeBag)
            
        btnPlus.rx.tap.asDriver(onErrorJustReturn: ())
            .drive(onNext: { [weak self] in
                guard let _self = self else { return }
                _self.viewModel.goNewAlarmDetail()
            }, onCompleted: {
                
            }) {
                
        }.disposed(by: disposeBag)
        
        
        viewModel.weatherData.subscribe(onNext: { [weak self] (weatherData) in
            guard let _self = self else { return }
            _self.vHeaderWeather = UINib.init(nibName: "HeaderWeatherView", bundle: nil).instantiate(withOwner: nil, options: nil).first as? HeaderWeatherView

            let url = weatherData.weather?.first?.icon
            let text = "\(weatherData.main?.tempMin ?? "")~\(weatherData.main?.tempMax ?? "")"
            _self.vHeaderWeather?.viewModel = HeaderWeatherVM.init(text, url)
            _self.tbAlarm.reloadData()
        }).disposed(by: disposeBag)
        
        
//        self.tbAlarm.rx.setDelegate(self)
//        .disposed(by: disposeBag)
        
    }
    
    func setNoDataView(isShow: Bool) {
        if isShow {
            if let noDataView = Bundle.main.loadNibNamed("NoDataView", owner: nil, options: nil)?.first as? NoDataView {
                noDataView.tag = 900
                self.view.addSubview(noDataView)
                noDataView.snp.makeConstraints {
                    $0.top.left.bottom.right.equalTo(self.tbAlarm)
                }
                self.view.layoutIfNeeded()
            }
        } else {
            if let noDataView = self.view.viewWithTag(900) as? NoDataView {
                noDataView.removeFromSuperview()
            }
        }
         
    }
}

// MARK: - 일반 함수
extension AlarmVC {
    
    @IBAction func tapBtnEdit(_ sender: Any) {
        viewModel.isEditing.accept(!viewModel.isEditing.value)
    }
    
}

// MARK: - UITable
extension AlarmVC: UITableViewDelegate {
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        // 헤더뷰 설정.
        if let header = self.vHeaderWeather {
            header.configure()
            return header
        }

        return nil
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if let header = self.vHeaderWeather {
            if header.viewModel.isShown {
                return 60
            }
        }
        return 0
    }
    
    // Override to support editing the table view.
//    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
//        if editingStyle == .delete {
//            let index = indexPath.row
//            self.viewModel.deleteRow(index: index)
//            // Delete the row from the data source
//            self.tbAlarm.beginUpdates()
//            self.tbAlarm.deleteRows(at: [indexPath], with: .middle)
//            self.tbAlarm.endUpdates()
//            Scheduler.shared.reSchedule()
//            self.tbAlarm.reloadData()
//        }
//    }

//    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
//        if self.viewModel.schedules == nil || self.viewModel.schedules.count == 0 {
//            if let view = Bundle.main.loadNibNamed("NoDataView", owner: nil, options: nil)?.first as? NoDataView {
//                return view
//            }
//        }
//        return nil
//    }

//    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
//        if self.viewModel.schedules.count == 0 {
//            return 300
//        }
//        return 0
//    }
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
