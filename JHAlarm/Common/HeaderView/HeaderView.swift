//
//  HeaderView.swift
//  JHAlarm
//
//  Created by 김제현 on 04/09/2019.
//  Copyright © 2019 김제현. All rights reserved.
//

// 스크린 크기
let SCREEN_WIDTH = UIScreen.main.bounds.size.width
let SCREEN_HEIGHT = UIScreen.main.bounds.size.height
let STATUS_HEIGHT = UIApplication.shared.statusBarFrame.size.height

class HeaderView: UIView {
    
    var maxHeaderHeight: CGFloat = 0
    var minHeaderHeight: CGFloat = 0
    
    @IBOutlet weak var headerTopConstraint: NSLayoutConstraint!     // default : 0
    @IBOutlet weak var headerHeightConstraint: NSLayoutConstraint!  // default : 168
    
    func updateHeader(_ newHeight:CGFloat) {
        
        // 위치 이동
        let moveY = self.maxHeaderHeight-newHeight
        
//        if vcType == "B" {
            self.bounds.origin.y = -moveY*1/40  // 위치
//        }
//        else {
//            self.bounds.origin.y = -moveY*1/3  // 위치
//        }
        
        // 투명도 설정
        let range = self.maxHeaderHeight - self.minHeaderHeight
        let rate = 1.0/range
        let alpha = rate*(newHeight-self.minHeaderHeight)
        self.alpha = alpha
    }
    
    /////////////////////////// Header Scroll ///////////////////////////
    /// 스크롤 이동중 실행
    func scrollViewDidScroll(scrollView: UIScrollView, previousScrollOffset:CGFloat) -> CGFloat {
        
        let scrollDiff = scrollView.contentOffset.y - previousScrollOffset
        
        let absoluteTop: CGFloat = 0
        let absoluteBottom: CGFloat = scrollView.contentSize.height + scrollView.contentInset.top + scrollView.contentInset.bottom - scrollView.frame.size.height
        
        let isScrollingDown = scrollDiff > 0 && scrollView.contentOffset.y > absoluteTop
        let isScrollingUp   = scrollDiff < 0 && scrollView.contentOffset.y < absoluteBottom
        
        // Header 높이를 새로 지정
        var newHeight = self.headerHeightConstraint.constant
        if isScrollingDown {
            newHeight = max(self.minHeaderHeight, self.headerHeightConstraint.constant - abs(scrollDiff))
        } else if isScrollingUp {
            if scrollView.contentOffset.y < 0 {
                newHeight = min(self.maxHeaderHeight, self.headerHeightConstraint.constant + abs(scrollDiff))
            }
        }
        
        // 새로 계산된 Header 높이를 적용 및 애니메이션 효과
        if newHeight != self.headerHeightConstraint.constant {
            self.headerHeightConstraint.constant = newHeight
            self.updateHeader(newHeight)
            scrollView.contentOffset = CGPoint(x: scrollView.contentOffset.x, y: previousScrollOffset)
        }
        
        return scrollView.contentOffset.y
    }
    
    func scrollViewDidScroll(tableView: UITableView, previousScrollOffset:CGFloat) -> CGFloat {
        
        let scrollDiff = tableView.contentOffset.y - previousScrollOffset
        
        let absoluteTop: CGFloat = 0
        let absoluteBottom: CGFloat = tableView.contentSize.height + tableView.contentInset.top + tableView.contentInset.bottom - tableView.frame.size.height
        
        let isScrollingDown = scrollDiff > 0 && tableView.contentOffset.y > absoluteTop
        let isScrollingUp   = scrollDiff < 0 && tableView.contentOffset.y < absoluteBottom
        
        // Header 높이를 새로 지정
        var newHeight = self.headerHeightConstraint.constant
        if isScrollingDown {
            newHeight = max(self.minHeaderHeight, self.headerHeightConstraint.constant - abs(scrollDiff))
        } else if isScrollingUp {
            if tableView.contentOffset.y < 0 {
                newHeight = min(self.maxHeaderHeight, self.headerHeightConstraint.constant + abs(scrollDiff))
            }
        }
        
        // 새로 계산된 Header 높이를 적용 및 애니메이션 효과
        if newHeight != self.headerHeightConstraint.constant {
            self.headerHeightConstraint.constant = newHeight
            self.updateHeader(newHeight)
            tableView.contentOffset = CGPoint(x: tableView.contentOffset.x, y: previousScrollOffset)
        }
        
        return tableView.contentOffset.y
    }
}

