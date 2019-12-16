//
//  UIScrollViewExtension.swift
//  Mwave
//
//  Created by 김제현 on 2018. 3. 13..
//  Copyright © 2018년 김제현. All rights reserved.
//

import UIKit
import RxSwift

extension UIScrollView {
    func updateContentView() {
        contentSize.height = subviews.sorted(by: { $0.frame.maxY < $1.frame.maxY }).last?.frame.maxY ?? contentSize.height
    }
    
    
    func updateContentViewSize() {
        var newHeight: CGFloat = 0
        for view in subviews {
            let ref = view.frame.origin.y + view.frame.height
            if ref > newHeight {
                newHeight = ref
            }
        }
        let oldSize = contentSize
        let newSize = CGSize(width: oldSize.width, height: newHeight + 100)
        contentSize = newSize
    }
    
    func needsMore() -> Observable<UIScrollView> {
        return self.rx.didScroll.map { _ in self }
            .filter {
                let offsetY = $0.contentOffset.y
                let scrollerHeight = $0.bounds.size.height
                let scrollRemain = $0.contentSize.height - offsetY - scrollerHeight
                return scrollRemain < scrollerHeight
        }
    }
    
    func calcScrollViewEndingPosition() -> CGPoint {
        let W = self.contentSize.width
        let w = self.bounds.width
        let r = self.contentInset.right
        
        let H = self.contentSize.height
        let h = self.bounds.height
        let b = self.contentInset.bottom
        
        return CGPoint(x: W - w + r, y: H - h + b)
    }
}
