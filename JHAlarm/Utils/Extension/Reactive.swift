//
//  UITableView+Rx.swift
//  JHAlarm
//
//  Created by Mephrine on 2019/11/29.
//  Copyright © 2019 김제현. All rights reserved.
//

import Foundation
import UIKit
import RxSwift
import RxCocoa

extension Reactive where Base: UITableView {
    func isEmpty() -> Binder<Bool>{
        return Binder(base) { tableView, isEmpty in
            if isEmpty {
                tableView.setNoDataView()
            } else {
                tableView.removeNoDataView()
            }
        }
    }
    
    func isEmptySetNoDataLabel(message: String, font: UIFont, _ textColor: UIColor = .black) -> Binder<Bool> {
        return Binder(base) { tableView, isEmpty in
            if isEmpty {
                tableView.setNoDataLabel(message, font: font, textColor)
            } else {
                tableView.removeNoDataView()
            }
        }
    }
}
