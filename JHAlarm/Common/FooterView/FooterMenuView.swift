//
//  FooterMenuView.swift
//  JHAlarm
//
//  Created by 김제현 on 12/08/2019.
//  Copyright © 2019 김제현. All rights reserved.
//

import UIKit

class FooterMenuView: FooterView {
    
    // 변수
    @IBOutlet weak var menuStackView: UIStackView!
    @IBOutlet weak var borderLine: UIView!
    
    @IBOutlet var constFooterHeight: NSLayoutConstraint!
    var indicatorBar: UIView?
    var menuBtnHandler:((Int) -> Void)?
    
    // 공통푸터 생성
    static func initView(_ view:UIView, menuBtnHandler:((Int) -> Void)?) -> FooterMenuView {
        let footer = UINib(nibName: "FooterMenuView", bundle: nil).instantiate(withOwner: nil, options: nil)[0] as! FooterMenuView
        view.addSubview(footer)
        
        // 초기화
        footer.initConstraint()
        footer.showFooter()
        
        footer.initIndicatorBar()
        
        footer.menuBtnHandler = menuBtnHandler
        
        let themeIndex = MenuConfig.Alarm.rawValue
        footer.selectTab(index: themeIndex)
        
        return footer
    }
    
    func initIndicatorBar() {
        self.indicatorBar = UIView()

        if let indicatorBar = self.indicatorBar {
            self.addSubview(indicatorBar)
            
            indicatorBar.snp.makeConstraints { (make) in
                make.top.equalTo(self)
                make.left.right.equalTo(self.menuStackView.subviews[MenuConfig.Alarm.rawValue])
                make.height.equalTo(3)
            }
        }
    }
    
    func selectTab(index: Int) {
        self.initTabImage()
        self.activeTabImage(index: index)
    }
    
    /// 알람 터치 시
    @IBAction func menuPressed(_ sender: Any) {
        /// GA Event 코드
        
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
    
    func initTabImage() {
        for i in 0 ..< self.menuStackView.subviews.count {
            let imageName = getTabImageName(index: i) + "_off"
            
            if let img = (self.menuStackView.subviews[i]).subviews.first as? UIImageView {
                img.image = UIImage(named: imageName)
            }
        }
    }
    
    func activeTabImage(index: Int) {
        let imageName = getTabImageName(index: index) + "_on"
        
        if let img = (self.menuStackView.subviews[index]).subviews.first as? UIImageView {
            img.image = UIImage(named: imageName)
        }
        
    }
    
    func getTabImageName(index: Int) -> String {
        var imageName = "menu"
        
        switch index {
        case MenuConfig.Alarm.rawValue :
            imageName += "_alarm"
            break
        case MenuConfig.StopWatch.rawValue :
            imageName += "_stop"
            break
        case MenuConfig.Timer.rawValue :
            imageName += "_timer"
            break
        case MenuConfig.Watch.rawValue :
            imageName += "_current"
            break
        case MenuConfig.Setting.rawValue :
            imageName += "_setting"
            break
        default:
            imageName = "_alarm"
            break
        }
        
        return imageName
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
