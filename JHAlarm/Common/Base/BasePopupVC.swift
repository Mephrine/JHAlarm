//
//  BasePopupVC.swift
//  JHAlarm
//
//  Created by Mephrine on 16/10/2019.
//  Copyright © 2019 김제현. All rights reserved.
//

import Foundation

class BasePopupVC: BaseVC {
    
    @IBOutlet weak var vDim: UIView!
    @IBOutlet weak var vContainer: UIView!
    @IBOutlet weak var stvContainer: UIStackView!
    @IBOutlet weak var constContainerVertical: NSLayoutConstraint!
    
    override func initView() {
        self.view.layoutIfNeeded()
        constContainerVertical.constant = self.view.frame.size.height
    }
    
    func showAnim(_ completeion: @escaping ()->()) {
        constContainerVertical.constant = 0
        UIView.animate(withDuration: 0.3, animations: { [weak self] in
            if let _self = self {
                _self.vDim.alpha = 1.0
                _self.view.layoutIfNeeded()
            }
        }) { (complete) in
            completeion()
        }
    }
    
    func hideAnim() {
        constContainerVertical.constant = self.view.frame.size.height
        UIView.animate(withDuration: 0.3, animations: { [weak self] in
            if let _self = self {
                _self.vDim.alpha = 0.0
                _self.view.layoutIfNeeded()
            }
            }, completion: { [weak self] completion in
                if let _self = self {
                    _self.view.removeFromSuperview()
                    _self.removeFromParent()
                }
            }
        )
    }
    
    @IBAction func btnCancelPressed(_ sender: UIButton) {
           self.hideAnim()
       }
       
       @IBAction func btnCompletePressed(_ sender: UIButton) {
           self.hideAnim()
       }
}
