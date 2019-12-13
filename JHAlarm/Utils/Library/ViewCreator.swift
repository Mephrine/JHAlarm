//
//  ViewCreater.swift
//  JHAlarm
//
//  Created by 김제현 on 06/09/2019.
//  Copyright © 2019 김제현. All rights reserved.
//

import SnapKit
import UIKit

@discardableResult
/**
 사용법
 createView(UITableView(), parent: self.view, setting: { v in
 v.rowHeight = UITableView.automaticDimension
 v.register(cellType: AlarmTableCell.self)
 */
public func createView<T>(_ view: T,
                          parent: UIView?,
                          setting: ((T) -> Void)? = nil,
                          constraint: ((ConstraintMaker) -> Void)? = nil) -> T where T: UIView {
    
    switch parent {
    case let stack as UIStackView:
        stack.addArrangedSubview(view)
    case let collectionCell as UICollectionViewCell:
        collectionCell.contentView.addSubview(view)
    case let tableCell as UITableViewCell:
        tableCell.contentView.addSubview(view)
    default:
        parent?.addSubview(view)
    }
    
    if let setting = setting {
        setting(view)
    }
    
    if let constraint = constraint {
        view.snp.makeConstraints(constraint)
    }
    return view
}

extension ConstraintMaker {
    public func aspectRatio(_ x: Int, by y: Int, self instance: ConstraintView) {
        self.width.equalTo(instance.snp.height).multipliedBy(x / y)
    }
}
