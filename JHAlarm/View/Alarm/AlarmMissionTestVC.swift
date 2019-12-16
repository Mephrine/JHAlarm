//
//  AlarmMissionTestVC.swift
//  JHAlarm
//
//  Created by Mephrine on 21/11/2019.
//  Copyright © 2019 김제현. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa
import UICollectionViewFlexLayout
import Then
import RxDataSources
import Reusable

class AlarmMissionTestVC: BaseVC, StoryboardBased, ViewModelBased {
    @IBOutlet var btnClose: UIButton!
    @IBOutlet var vHeader: HeaderView!
    //    @IBOutlet weak var cvMission: UICollectionView!
    
    fileprivate let reuseCellNm = "AlarmMissionCell"
    //    fileprivate let dataSource: RxCollectionViewSectionedReloadDataSource<AlarmMissionModel>
    
    let cvMission = UICollectionView(
        frame: .zero,
        collectionViewLayout: UICollectionViewFlexLayout()
    ).then{
        $0.backgroundColor = .clear
        $0.alwaysBounceVertical = true
        $0.register(cellType: AlarmMissionCell.self)
    }
    
    // ViewModel
    var viewModel: AlarmMissionVM!
    
    
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
    
    override func initView() {
        self.view.addSubview(cvMission)
        setConstraints()
    }
    
    override func setBind() {
        cvMission.rx.setDelegate(self)
            .disposed(by: disposeBag)
        
        //   미션 리스트 바인딩
        //        viewModel.missionList.bind(to: self.cvMission.rx.items(cellIdentifier: reuseCellNm)) { row, element, baseCell in
        //            let indexPath = IndexPath(row: row, section: 0)
        //
        //            if let cell = self.cvMission.dequeueReusableCell(withReuseIdentifier: self.reuseCellNm, for: indexPath) as? AlarmMissionCell {
        //                let vm = AlarmMissionCellVM.init(viewModel: self.viewModel, element: element, row: row)
        //                cell.configure(viewModel: vm)
        //            }
        //        }.disposed(by: disposeBag)
        viewModel.missionList.bind(to: self.cvMission.rx.items(dataSource: self.dataSourceFactory()))
            .disposed(by: disposeBag)
        
        // 선택된 아이템 ViewModel Data하고 바인딩.
        self.cvMission.rx.modelSelected(MissionModel.self)
            .distinctUntilChanged()
            .bind(to: self.viewModel.selectedItem)
            .disposed(by: disposeBag)
        
        self.viewModel.selectedItem.asDriver(onErrorJustReturn: MissionModel.init(wakeMission: .Base, level: 0, numberOfTimes: 0))
            .drive(onNext: { [unowned self] (mission) in
                self.cvMission.reloadData()
                self.viewModel.move(mission)
            }).disposed(by: disposeBag)
        
        // 뒤로가기 클릭 시, Coordinator 통해서 해당 뷰컨트롤러 컨트롤.
//        self.btnClose.rx.tap
//            .debounce(0.3, scheduler: MainScheduler.instance)
//            .subscribe(onNext: {
//                self.viewModel.dismiss()
//            }).disposed(by: disposeBag)
    }
    
    private func dataSourceFactory() -> RxCollectionViewSectionedReloadDataSource<AlarmMissionModel> {
        return .init (configureCell: { (dataSource, collectionView, indexPath, item) -> UICollectionViewCell in
            if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: self.reuseCellNm, for: indexPath) as? AlarmMissionCell {
                let vm = AlarmMissionCellVM.init(viewModel: self.viewModel, element: item, row: indexPath.row)
                cell.configure(viewModel: vm)
                return cell
            }
            return UICollectionViewCell()
        })
    }
    
    func setConstraints() {
        cvMission.snp.makeConstraints {
            $0.top.left.bottom.right.equalTo(self.view)

        }
    }
    
    
}

extension AlarmMissionTestVC: UICollectionViewDelegateFlexLayout {
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewFlexLayout,
        verticalSpacingBetweenSectionAt section: Int,
        and nextSection: Int
    ) -> CGFloat {
        return .zero
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewFlexLayout,
        paddingForSectionAt section: Int
    ) -> UIEdgeInsets {
        return .zero
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewFlexLayout,
        paddingForItemAt indexPath: IndexPath
    ) -> UIEdgeInsets {
        return .zero
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewFlexLayout,
        verticalSpacingBetweenItemAt indexPath: IndexPath,
        and nextIndexPath: IndexPath
    ) -> CGFloat {
        return 10
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewFlexLayout,
        sizeForItemAt indexPath: IndexPath
    ) -> CGSize {
        let maxWidth = collectionViewLayout.maximumWidth(forItemAt: indexPath) - 20
        return CGSize(width: maxWidth / 3, height: 100)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewFlexLayout, horizontalSpacingBetweenItemAt indexPath: IndexPath, and nextIndexPath: IndexPath) -> CGFloat {
        return 10
    }
}

