//
//  UIViewControllerExtension.swift
//  JHAlarm
//
//  Created by Mephrine on 2020/06/09.
//  Copyright © 2020 김제현. All rights reserved.
//

import UIKit

extension UIViewController {
    static func instantiate (storyBoardName: String) -> Self {
        let sb = UIStoryboard.init(name: storyBoardName, bundle: nil)
        if let viewController = sb.instantiateViewController(withIdentifier: String(describing: self)) as? Self {
            return viewController
        }
        return Self.instantiate(storyBoardName: storyBoardName)
    }
}
