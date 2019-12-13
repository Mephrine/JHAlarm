//
//  FooterView.swift
//  JHAlarm
//
//  Created by 김제현 on 12/08/2019.
//  Copyright © 2019 김제현. All rights reserved.
//

import Foundation
import UIKit

class FooterView: UIView {
    
    let Anim_Duration: Double = 0.2
    var footerHeight: CGFloat!
    
    func initConstraint() {
        self.footerHeight = (self.parentViewController() as? BaseVC)?.footerInset ?? 58
    }
    
    func createBlurEffect(isDark: Bool = true) {
        let blurEffect:UIBlurEffect?
        if isDark {
            blurEffect = UIBlurEffect(style: UIBlurEffectStyle.dark)
        }else{
            blurEffect = UIBlurEffect(style: UIBlurEffectStyle.light)
        }
        
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        self.insertSubview(blurEffectView, at: 0)
        
        blurEffectView.snp.makeConstraints { (make) in
            make.top.bottom.left.right.equalTo(self)
        }
    }
}

extension FooterView {
    
    // FooterView Animation
    func hideFooterAnim(completion: @escaping ()->()) {
        self.hideFooter()
        UIView.animate(withDuration: Anim_Duration, animations: {
            self.superview!.layoutIfNeeded()
        }) { (finished) in
            completion()
        }
    }
    
    func showFooterAnim(completion: @escaping ()->()) {
        self.showFooter()
        UIView.animate(withDuration: Anim_Duration, animations: {
            self.superview!.layoutIfNeeded()
        }) { (finished) in
            completion()
        }
    }
    
    
    func hideFooter() {
        self.snp.remakeConstraints { (make) in
            make.left.right.equalTo(self.superview!)
            make.bottom.equalTo(self.superview!).offset(self.footerHeight)
            make.height.equalTo(self.footerHeight)
        }
    }
    
    func showFooter() {
        self.snp.remakeConstraints { (make) in
            make.left.right.equalTo(self.superview!)
            make.bottom.equalTo(self.superview!).offset(0)
            make.height.equalTo(self.footerHeight)
        }
    }
}
