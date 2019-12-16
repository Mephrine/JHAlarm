//
//  NavigationExtension.swift
//  Mwave
//
//  Created by 김제현 on 2017. 8. 14..
//  Copyright © 2017년 김제현. All rights reserved.
//

import UIKit

extension UINavigationController{
    
    public func pushViewController(
        _ viewController: UIViewController,
        animated: Bool,
        completion: @escaping () -> Void)
    {
        self.navigationController?.pushViewController(viewController, animated: animated)
        
        guard animated, let coordinator = transitionCoordinator else {
            completion()
            return
        }
        
        coordinator.animate(alongsideTransition: nil) { _ in completion() }
    }
    
    public func pushStoryBoardViewController(
        _ storyBoardNm: String,
        _ viewControllerNm: String,
        animated: Bool)
    {
        let storyboard = UIStoryboard(name: storyBoardNm, bundle: nil)
        let viewController   = storyboard.instantiateViewController(withIdentifier: viewControllerNm)
        
//        self.navigationController?.pushViewController(viewController, animated: true)
        pushViewController(viewController, animated: animated)
    }
    
    public func pushStoryBoardViewControllerBlock(
        _ storyBoardNm: String,
        _ viewControllerNm: String,
        animated: Bool,
        completion: @escaping () -> Void)
    {
        let storyboard = UIStoryboard(name: storyBoardNm, bundle: nil)
        let viewController   = storyboard.instantiateViewController(withIdentifier: viewControllerNm)
        
        //        self.navigationController?.pushViewController(viewController, animated: true)
        pushViewController(viewController, animated: animated)
        
        guard animated, let coordinator = transitionCoordinator else {
            completion()
            return
        }
        
        coordinator.animate(alongsideTransition: nil) { _ in completion() }
    }
    
    func popToHome(completion: @escaping ()->()) {
        CATransaction.begin()
        CATransaction.setCompletionBlock(completion)
        self.popToViewController(self.viewControllers[1], animated: true)
        CATransaction.commit()
    }
}
