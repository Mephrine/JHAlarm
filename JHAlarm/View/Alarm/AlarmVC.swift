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
    private var tbAlarm: UITableView?
    private var vHeaderWeather: HeaderWeatherView?
    @IBOutlet var headerView: HeaderView!
    
    // ViewModel
    var viewModel: AlarmVM?
    private lazy var input = AlarmVM.Input()
    private lazy var output = viewModel?.transform(input: input)
    
    // Variable
    private var previousScrollOffset: CGFloat = 0.0
    
    @IBOutlet private var btnPlus: UIButton!
    @IBOutlet private weak var btnEdit: UIButton!
    
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
        
        guard let tbAlarm = self.tbAlarm else { return }
        
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
    }
    
    // 뷰 바인딩하기.
    override func setBind() {
        guard let tbAlarm = self.tbAlarm, let viewModel = self.viewModel else { return }
        
        /// dataSource
        let realmDataSource = RxTableViewRealmDataSource<AlarmModel>.init(cellIdentifier: "AlarmTableCell", cellType: AlarmTableCell.self) { cell, indexPath, item in
            cell.configure(item)
        }
        
        /// Loading
        viewModel.isLoading
            .subscribeOn(Schedulers.main)
            .subscribe(onNext: { [weak self] isLoading in
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
                   
        log.d("self.viewModel.alarmSchedule : \(viewModel.alarmSchedule.count())")
        
        
        tbAlarm.rx.realmModelSelected(AlarmModel.self)
            .asDriver()
            .drive(onNext : { [weak self] in
                viewModel.goEditAlarmDetail(model: $0)
            })
            .disposed(by: disposeBag)
       
        tbAlarm.rx.itemDeleted.asDriver()
            .drive(onNext: { [weak self] indexPath in
                guard let _self = self, let tbAlarm = _self.tbAlarm else { return }
                let index = indexPath.row
                viewModel.deleteRow(index: index)
                // Delete the row from the data source
                tbAlarm.beginUpdates()
                tbAlarm.deleteRows(at: [indexPath], with: .middle)
                tbAlarm.endUpdates()
                Scheduler.shared.reSchedule()
            })
            .disposed(by: disposeBag)
        
                
        viewModel.isEditing
            .asDriver()
            .drive(onNext: { [weak self] in
                guard let _self = self, let tbAlarm = _self.tbAlarm else { return }
                if $0 {
                    _self.btnEdit.setTitle("Done", for: .normal)
                    tbAlarm.setEditing(true, animated: true)
                } else {
                    _self.btnEdit.setTitle("Edit", for: .normal)
                    tbAlarm.setEditing(false, animated: true)
                }
            }).disposed(by: disposeBag)
            
        btnPlus.rx.tap
            .asDriver(onErrorJustReturn: ())
            .drive(onNext: { [weak self] in
                guard let _self = self else { return }
                viewModel.goNewAlarmDetail()
            }, onCompleted: {
                
            }) {
                
        }.disposed(by: disposeBag)
        
        
        viewModel.weatherData
            .subscribe(onNext: { [weak self] (weatherData) in
                guard let _self = self, let tbAlarm = _self.tbAlarm else { return }
                _self.vHeaderWeather = UINib.init(nibName: "HeaderWeatherView", bundle: nil).instantiate(withOwner: nil, options: nil).first as? HeaderWeatherView

                let url = weatherData.weather?.first?.icon
                let text = "\(weatherData.main?.tempMin ?? "")~\(weatherData.main?.tempMax ?? "")"
                _self.vHeaderWeather?.viewModel = HeaderWeatherVM.init(text, url)
                tbAlarm.reloadData()
            }).disposed(by: disposeBag)
    }
    
    func setNoDataView(isShow: Bool) {
        if isShow {
            if let noDataView = Bundle.main.loadNibNamed("NoDataView", owner: nil, options: nil)?.first as? NoDataView {
                noDataView.tag = 900
                self.view.addSubview(noDataView)
                noDataView.snp.makeConstraints { [weak self] in
                    guard let tbAlarm = self?.tbAlarm else { return }
                    $0.top.left.bottom.right.equalTo(tbAlarm)
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
        guard let viewModel = self.viewModel else { return }
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
    }
}
