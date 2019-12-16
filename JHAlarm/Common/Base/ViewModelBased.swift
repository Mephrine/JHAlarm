//
//  ViewModelBased.swift
//  JHAlarm
//
//  Created by Mephrine on 13/11/2019.
//  Copyright © 2019 김제현. All rights reserved.
//

import UIKit
import Reusable

protocol BaseVCProtocol {
}

//protocol ServicesViewModel: BaseVCProtocol {
//    associatedtype Services
//    var services: Services! { get set }
//}

protocol ViewModelBased: class {
    associatedtype ViewModelType
    var viewModel: ViewModelType! { get set }
}

extension ViewModelBased where Self: StoryboardBased & UIViewController {
    static func instantiate<ViewModelType> (withViewModel viewModel: ViewModelType) -> Self where ViewModelType == Self.ViewModelType {
        let viewController = Self.instantiate()
        viewController.viewModel = viewModel
        return viewController
    }
    
    static func instantiate<ViewModelType> (withViewModel viewModel: ViewModelType, storyBoardName: String) -> Self where ViewModelType == Self.ViewModelType {
        let sb = UIStoryboard.init(name: storyBoardName, bundle: nil)
        if let viewController = sb.instantiateViewController(withIdentifier: String(describing: self)) as? Self {
            viewController.viewModel = viewModel
            return viewController
        }
        return Self.instantiate(withViewModel: viewModel)
    }
}

//extension ViewModelBased where Self: StoryboardBased & UIViewController, ViewModelType: ServicesViewModel {
//    static func instantiate<ViewModelType, ServicesType> (withViewModel viewModel: ViewModelType, andServices services: ServicesType) -> Self where ViewModelType == Self.ViewModelType, ServicesType == Self.ViewModelType.Services {
//        let viewController = Self.instantiate()
//        viewController.viewModel = viewModel
//        viewController.viewModel.services = services
//        return viewController
//    }
//
//    static func instantiate<ViewModelType, ServicesType> (withViewModel viewModel: ViewModelType, andServices services: ServicesType, storyBoardName: String) -> Self where ViewModelType == Self.ViewModelType, ServicesType == Self.ViewModelType.Services {
//        let sb = UIStoryboard.init(name: storyBoardName, bundle: nil)
//        if let viewController = sb.instantiateViewController(withIdentifier: String(describing: self)) as? Self {
//            viewController.viewModel = viewModel
//            viewController.viewModel.services = services
//            return viewController
//        }
//        return Self.instantiate(withViewModel: viewModel)
//    }
//}
