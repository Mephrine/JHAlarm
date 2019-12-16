//
//  BaseVC.swift
//  JHAlarm
//
//  Created by 김제현 on 29/08/2019.
//  Copyright © 2019 김제현. All rights reserved.
//

import UIKit
import RxSwift
import NVActivityIndicatorView
import Reusable

class BaseVC: UIViewController, NVActivityIndicatorViewable {
    var statusBarShouldBeHidden = false
    var disposeBag = DisposeBag()
    
    
    override var prefersStatusBarHidden: Bool {
        return statusBarShouldBeHidden
    }
    
    override var preferredStatusBarUpdateAnimation: UIStatusBarAnimation {
        return .fade
    }
    
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 자동으로 스크롤뷰 인셋 조정하는 코드 막기
        self.automaticallyAdjustsScrollViewInsets = false
        
        // Enable swipe back when no navigation bar
        navigationController?.interactivePopGestureRecognizer?.delegate = nil
        
        initView()
        setBind()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = true
        
    }

    func initView() {
        
    }
    
    func resetView() {
        
    }
    
    func setBind() {
        
    }
    
    // Top Anchor
    var safeAreaTopAnchor: CGFloat {
        if #available(iOS 11.0, *) {
            let window = UIApplication.shared.keyWindow
            var topPadding = window?.safeAreaInsets.top
            
            if topPadding == 0 {
                topPadding = self.topLayoutGuide.length
                if topPadding == 0 {
                    topPadding = UIApplication.shared.statusBarFrame.size.height
                }
            }
            
            return topPadding ?? STATUS_HEIGHT
        } else {
            return STATUS_HEIGHT
        }
    }
    
    // Bottom Anchor
    var safeAreaBottomAnchor: CGFloat {
        if #available(iOS 11.0, *) {
            let window = UIApplication.shared.keyWindow
            let bottomPadding = window?.safeAreaInsets.bottom
            return bottomPadding!
        } else {
            return bottomLayoutGuide.length
        }
    }
    
    
    var footerInset: CGFloat {
        let FooterHeight: CGFloat = 58
        
        if #available(iOS 11.0, *) {
            let window = UIApplication.shared.keyWindow
            let bottomPadding = (window?.safeAreaInsets.bottom) ?? 0
            return bottomPadding + FooterHeight
        } else {
            return bottomLayoutGuide.length + FooterHeight
        }
    }
    
    // 상태바 숨기기
    func hideStatusAnim() {
        self.statusBarShouldBeHidden = true
        UIView.animate(withDuration: 0.25) {
            self.setNeedsStatusBarAppearanceUpdate()
        }
    }
    // 상태바 보이기
    func showStatusAnim() {
        self.statusBarShouldBeHidden = false
        UIView.animate(withDuration: 0.25) {
            self.setNeedsStatusBarAppearanceUpdate()
        }
    }
    
    /////Indicator
    func showIndicator(_ showing: Bool = true){
        if showing {
            let size = CGSize(width: 30, height: 30)
            startAnimating(size, message: "Loading...", type: .semiCircleSpin)
        } else {
            stopAnimating()
        }
    }
    
}
