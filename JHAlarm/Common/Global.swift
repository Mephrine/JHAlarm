//
//  Global.swift
//  JHAlarm
//
//  Created by 김제현 on 12/08/2019.
//  Copyright © 2019 김제현. All rights reserved.
//

import Foundation
import UIKit

class Global: NSObject {
    static let SCREEN_WIDTH = UIScreen.main.bounds.size.width
    static let SCREEN_HEIGHT = UIScreen.main.bounds.size.height
    static let STATUS_HEIGHT = UIApplication.shared.statusBarFrame.size.height
    
    static func openUrl(_ urlString: String, _ handler:(() -> Void)? = nil) {
        
        guard let url = URL(string: urlString) else {
            return //be safe
        }
        print("url : \(url)")
        if #available(iOS 10.0, *) {
            UIApplication.shared.open(url, options: [:]) { (result) in
                handler?()
            }
            
        } else {
            UIApplication.shared.openURL(url)
            handler?()
        }
    }
    
    static func findView<V>(superView: UIView, findView: UIView, type: V) -> Bool {
        for subView in superView.subviews {
            if subView is V {
                return true
            }
        }
        return false
    }
}

