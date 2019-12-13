//
//  FooterMenuView.swift
//  JHAlarm
//
//  Created by 김제현 on 12/08/2019.
//  Copyright © 2019 김제현. All rights reserved.
//

import Foundation

class FooterMenuView: FooterView {
    
    // 변수
    @IBOutlet weak var menuStackView: UIStackView!
    @IBOutlet weak var borderLine: UIView!
    
    var indicatorBar: UIView?
    var menuBtnHandler:((Int) -> Void)?
    
    // 공통푸터 생성
    static func initView(_ view:UIView, item: MvgModeConfig?, menuBtnHandler:((Int) -> Void)?) -> FooterMenuView {
        
        let footer = UINib(nibName: "FooterMenuView", bundle: nil).instantiate(withOwner: nil, options: nil)[0] as! FooterMenuView
        view.addSubview(footer)
        
        // 초기화
        footer.initConstraint()
        footer.showFooter()
        
        footer.initIndicatorBar()
        
        footer.menuBtnHandler = menuBtnHandler
        
        let themeIndex = MenuConfig.Theme.rawValue
        footer.selectTab(item: item, index: themeIndex)
        footer.setTabTheme(item: item)
        
        return footer
    }
    
    func initIndicatorBar() {
        self.indicatorBar = UIView()
        
        if let indicatorBar = self.indicatorBar {
            self.addSubview(indicatorBar)
            
            indicatorBar.snp.makeConstraints { (make) in
                make.top.equalTo(self)
                make.left.right.equalTo(self.menuStackView.subviews[MenuConfig.Theme.rawValue])
                make.height.equalTo(3)
            }
        }
    }
    
    func selectTab(item: MvgModeConfig?, index: Int) {
        guard let object = item else {
            return
        }
        self.initTabImage(item: object)
        self.activeTabImage(item: object, index: index)
    }
    
    /// 일반회원/MVG 회원 구분 별
    func setTabTheme(item: MvgModeConfig?) {
        guard let object = item else {
            return
        }
        self.backgroundColor               = object.getTabBgColor()
        self.indicatorBar?.backgroundColor = object.getTabIndicatorColor()
        self.borderLine.backgroundColor    = object.getTabBorderColor()
    }
    
    /// 엘패스 터치 시
    @IBAction func lpassPressed(_ sender: Any) {
        /// GA Event 코드
        CommonGoogleAnalytics.sendEventTracking("A0022", "U", "U", "U", "U", "APP_공통", "하단고정메뉴", "멀티패스", "")
        if let handler = self.menuBtnHandler {
            guard let button = sender as? UIButton else {
                return
            }
            handler(button.tag)
        }
    }
    
    /// 지점메인 터치 시
    @IBAction func branchPressed(_ sender: Any) {
        /// GA Event 코드
        CommonGoogleAnalytics.sendEventTracking("A0016", "U", "U", "U", "U","APP_공통", "하단고정메뉴", "지점", "")
        if let handler = self.menuBtnHandler {
            guard let button = sender as? UIButton else {
                return
            }
            handler(button.tag)
        }
    }
    
    /// 테마 터치 시
    @IBAction func themePressed(_ sender: Any) {
        /// GA Event 코드
        CommonGoogleAnalytics.sendEventTracking("A0009", "U", "U", "U", "U","APP_공통", "하단고정메뉴", "테마", "")
        if let handler = self.menuBtnHandler {
            guard let button = sender as? UIButton else {
                return
            }
            handler(button.tag)
        }
    }
    
    /// 통합검색 터치 시
    @IBAction func searchPressed(_ sender: Any) {
        /// GA Event 코드
        CommonGoogleAnalytics.sendEventTracking("A0007", "U", "U", "U", "U","APP_공통", "하단고정메뉴", "검색", "")
        if let handler = self.menuBtnHandler {
            guard let button = sender as? UIButton else {
                return
            }
            handler(button.tag)
        }
    }
    
    /// GNB 터치 시
    @IBAction func gnbPressed(_ sender: Any) {
        /// GA Event 코드
        CommonGoogleAnalytics.sendEventTracking("A0008", "U", "U", "U", "U","APP_공통", "하단고정메뉴", "전체메뉴", "")
        if let handler = self.menuBtnHandler {
            guard let button = sender as? UIButton else {
                return
            }
            handler(button.tag)
        }
    }
}

extension FooterMenuView {
    
    /// 인디케이터 애니메이션
    func animIndicatorBar(_ index: Int, isAnim:Bool = true) {
        if isAnim == true {
            self.indicatorBar?.snp.remakeConstraints { (make) in
                make.top.equalTo(self)
                make.left.right.equalTo(self.menuStackView.subviews[index])
                make.height.equalTo(3)
            }
            UIView.animate(withDuration: 0.3, animations: {
                self.layoutIfNeeded()
            })
        } else {
            self.indicatorBar?.snp.remakeConstraints { (make) in
                make.top.equalTo(self)
                make.left.right.equalTo(self.menuStackView.subviews[index])
                make.height.equalTo(3)
            }
        }
    }
    
    func initTabImage(item: MvgModeConfig) {
        for i in 0 ..< self.menuStackView.subviews.count {
            let imageName = item.getTabImageName(index: i)
            
            let button = (self.menuStackView.subviews[i]).subviews.first as! UIButton
            button.setImage(UIImage(named: imageName), for: .normal)
        }
    }
    
    func activeTabImage(item: MvgModeConfig, index: Int) {
        let imageName = item.getTabImageName(index: index) + "_fill"
        
        let button = (self.menuStackView.subviews[index]).subviews.first as! UIButton
        button.setImage(UIImage.init(named: imageName), for: .normal)
    }
    
}

// MARK: - UIScrollViewDelegate
extension FooterMenuView: UIScrollViewDelegate {
    
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        if(velocity.y > 0) {
            self.hideFooterAnim {}
        }else{
            self.showFooterAnim {}
        }
    }
}
