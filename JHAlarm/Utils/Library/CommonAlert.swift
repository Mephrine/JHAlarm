//
//  CommonAlert.swift
//  JHAlarm
//
//  Created by 김제현 on 09/09/2019.
//  Copyright © 2019 김제현. All rights reserved.
//

import UIKit

class CommonAlert {
    
    ////////////////////////// 공통 //////////////////////////
    // MARK: - 뷰 컨트롤러 생명주기
    static var viewController: UIViewController? {
        if let navi = UIApplication.shared.keyWindow?.rootViewController as? UINavigationController {
            return navi.viewControllers.first
        }
        return nil
    }
    
    /// 공통얼럿 : 버튼 1개 타입
    static func showAlertType1(vc:UIViewController? = viewController, title:String = "", message:String = "", completeTitle:String = "확인", _ completeHandler:(() -> Void)? = nil){
        if let viewController = vc {
            let alert = UIAlertController(title: title, message: message, preferredStyle:UIAlertController.Style.alert)
            let action1 = UIAlertAction(title:completeTitle, style: .default) { action in
                completeHandler?()
            }
            alert.addAction(action1)
            viewController.present(alert, animated: true, completion: nil)
        }
    }
    
    /// 공통얼럿 : 버튼 2개 타입
    static func showAlertType2(vc:UIViewController? = viewController, title:String = "", message:String = "", cancelTitle:String = "취소", completeTitle:String = "확인",  _ cancelHandler:(() -> Void)? = nil, _ completeHandler:(() -> Void)? = nil){
        if let viewController = vc {
            let alert = UIAlertController(title: title, message: message, preferredStyle:UIAlertController.Style.alert)
            let action1 = UIAlertAction(title:cancelTitle, style: .cancel) { action in
                cancelHandler?()
            }
            let action2 = UIAlertAction(title:completeTitle, style: .default) { action in
                completeHandler?()
            }
            alert.addAction(action1)
            alert.addAction(action2)
            viewController.present(alert, animated: true, completion: nil)
        }
    }
}
