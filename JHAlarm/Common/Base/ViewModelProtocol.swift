//
//  CommonViewModel.swift
//  JHAlarm
//
//  Created by Mephrine on 08/10/2019.
//  Copyright © 2019 김제현. All rights reserved.
//

import RxSwift

protocol ViewModelProtocol {
    associatedtype Input
    associatedtype Output
    
    func transform(input: Input?) -> Output
}

