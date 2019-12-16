//
//  AlarmSoundVC.swift
//  JHAlarm
//
//  Created by Mephrine on 16/10/2019.
//  Copyright © 2019 김제현. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa
import RxDataSources
import Reusable

typealias SoundDataSource = RxTableViewSectionedReloadDataSource<SoundSection>

class AlarmSoundVC: BaseVC, StoryboardBased, ViewModelBased {
    //MARK: IBOutlet
    @IBOutlet var tbSound: UITableView!
    @IBOutlet var btnSelect: UIButton!
    @IBOutlet var btnClose: UIButton!
    
    //MARK: Global Variable
    // ViewModel
    var viewModel: AlarmSoundVM!
    
    override func viewDidLoad() {
        super.viewDidLoad()
                
    }
    
    private var soundDataSource: SoundDataSource {
        return SoundDataSource.init(configureCell: { dataSource, tableView, indexPath, item in
            if let cell = tableView.dequeueReusableCell(withIdentifier: "SoundItemCell") as? SoundItemCell  {
                let viewModel = SoundItemCellVM.init(item: item, isSelected: self.viewModel.isSelectedItem(item: item))
                cell.configure(viewModel: viewModel)
                return cell
            }
            else {
                return UITableViewCell()
            }
        },titleForHeaderInSection: { dataSource, index in
            return dataSource.sectionModels[index].category
        })
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.viewModel.stopSound()
    }
    
    deinit {
        self.viewModel.stopSound()
    }
    
    override func initView() {
        tbSound.rowHeight = UITableView.automaticDimension
        tbSound.estimatedRowHeight = 100
        tbSound.separatorStyle = .none
        tbSound.backgroundColor = .clear
        tbSound.tableHeaderView?.backgroundColor = UIColor.yellow
        tbSound.tableHeaderView?.tintColor = UIColor.blue
        
        if #available(iOS 11.0, *) {
            tbSound.contentInsetAdjustmentBehavior = .never
        }
    }
    
    override func setBind() {
        tbSound.rx.setDelegate(self)
            .disposed(by: disposeBag)
        
        // 테이블뷰와 리스트 데이터 바인딩
        viewModel.soundData.bind(to: self.tbSound.rx.items(dataSource: soundDataSource))
            .disposed(by: disposeBag)
        
        // 테이블뷰 셀렉트된 아이템하고 ViewModel Subject 바인딩.
        self.tbSound.rx.modelSelected(AlarmSound.self)
            .distinctUntilChanged()
            .subscribeOn(Schedulers.main)
            .subscribe(onNext: { [weak self] in
                guard let _self = self else { return }
                _self.viewModel.selectSound(element: $0)
            })
//            .bind(to: viewModel.selectSound)
            .disposed(by: disposeBag)
        
        viewModel.selectedSound.asDriver(onErrorJustReturn: .Base0)
            .drive(onNext: { [weak self] (item) in
                guard let _self = self else { return }
                _self.tbSound.reloadData()
            }).disposed(by: disposeBag)
    
        self.btnClose.rx.tap
            .debounce(0.3, scheduler: MainScheduler.instance)
            .subscribe( onNext: { [weak self] in
                guard let _self = self else { return }
                _self.viewModel.dismiss()
        }).disposed(by: disposeBag)
            
        
        self.btnSelect.rx.tap
            .debounce(0.3, scheduler: MainScheduler.instance)
            .subscribe( onNext:  { [weak self] in
                guard let _self = self else { return }
                _self.viewModel.selectSound()
        }).disposed(by: disposeBag)
        
//        self.btnSelect.rx.tap.asDriver(onErrorJustReturn: ())
//            .debounce(0.3)
//            .drive { [unowned self] in
//                self.viewModel.selectSound()
//        }.disposed(by: disposeBag)
    }

}

extension AlarmSoundVC: UITableViewDelegate {
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        if let headerView = view as? UITableViewHeaderFooterView {
            headerView.backgroundView?.backgroundColor = COLOR_LIGHT_BG_LIST
            headerView.textLabel?.setFontMedium(17)
        }
    }
}
