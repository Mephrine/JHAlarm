//
//  UITableViewExtension.swift
//  JHAlarm
//
//  Created by 김제현 on 12/08/2019.
//  Copyright © 2019 김제현. All rights reserved.
//

import UIKit

extension UITableView {
    func reloadData(completion: @escaping ()->()) {
        DispatchQueue.main.async {
            UIView.animate(withDuration: 0, animations: {
                self.reloadData()
            }) { _ in
                completion()
            }
        }
    }
    
    func scrollToFirstRow() {
        let indexPath = IndexPath.init(row: 0, section: 0)
        
        DispatchQueue.main.async {
            self.scrollToRow(at: indexPath, at: .top, animated: true)
        }
    }
    
    func scrollToLastRow(itemSize: Int) {
        let indexPath = IndexPath.init(row: itemSize - 1, section: 0)
        
        DispatchQueue.main.async {
            self.scrollToRow(at: indexPath, at: .bottom, animated: true)
        }
    }
    
    func scrollToSelectedRow() {
        let selectedRows = self.indexPathsForSelectedRows
        
        if let selectedRow = selectedRows?[0] {
            DispatchQueue.main.async {
                self.scrollToRow(at: selectedRow, at: .middle, animated: true)
            }
        }
    }
    
    func scrollToHeader() {
        let rect = CGRect(x: 0, y: 0, width: 1, height: 1)
        
        DispatchQueue.main.async {
            self.scrollRectToVisible(rect, animated: true)
        }
    }
    
    func scrollToTop() {
        DispatchQueue.main.async {
            let pt = CGPoint.init(x: 0, y: UIApplication.shared.statusBarFrame.height)
            self.setContentOffset(pt, animated: true)
        }
    }
    
    func reloadAnim(animation: UITableView.RowAnimation) {
        let range = NSMakeRange(0, numberOfSections)
        let sections = NSIndexSet(indexesIn: range)
        reloadSections(sections as IndexSet, with: animation)
    }
}


