//
//  UITableView+Rx.swift
//  JHAlarm
//
//  Created by Mephrine on 2019/11/29.
//  Copyright © 2019 김제현. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

extension UITableView {
    func setNoDataView() {
        if let view = Bundle.main.loadNibNamed("NoDataView", owner: nil, options: nil)?.first as? NoDataView {
            self.isScrollEnabled = false
            self.backgroundView = view
            self.separatorStyle = .none
        }
    }
    
    func setNoDataLabel(_ message: String, font: UIFont, _ textColor: UIColor) {
        let label = UILabel().then {
            $0.text = message
            $0.font = font
            $0.sizeToFit()
            $0.textColor = textColor
            $0.textAlignment = .center
        }
        self.isScrollEnabled = false
        self.backgroundView = label
        self.separatorStyle = .none
    }
    
    func removeNoDataView() {
        self.isScrollEnabled = true
        self.backgroundView = nil
    }
    
}
