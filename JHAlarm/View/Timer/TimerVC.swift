//
//  TimerVC.swift
//  JHAlarm
//
//  Created by 김제현 on 04/09/2019.
//  Copyright © 2019 김제현. All rights reserved.
//

import Foundation

class TimerVC: BaseVC {
    var previousScrollOffset: CGFloat = 0.0
    @IBOutlet var tbAlarm: UITableView!
    
    @IBOutlet var headerView: HeaderView!
    
    
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
}

// MARK: - 지점메인 UIScrollViewDelegate
extension TimerVC: UIScrollViewDelegate {
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
        self.previousScrollOffset = self.headerView.scrollViewDidScroll(tableView: self.tbAlarm, previousScrollOffset: self.previousScrollOffset)
        
    }
}
