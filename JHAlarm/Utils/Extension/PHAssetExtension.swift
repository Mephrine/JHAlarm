//
//  PHAssetExtension.swift
//  JHAlarm
//
//  Created by 김제현 on 12/08/2019.
//  Copyright © 2019 김제현. All rights reserved.
//

import UIKit
import Photos

extension PHAsset {
    var originalFilename: String? {
        var fname:String?
        
        if #available(iOS 9.0, *) {
            let resources = PHAssetResource.assetResources(for: self)
            if let resource = resources.first {
                fname = resource.originalFilename
            }
        }
        
        if fname == nil {
            fname = self.value(forKey: "filename") as? String
        }
        
        return fname
    }
}

