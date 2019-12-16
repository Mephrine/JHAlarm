//
//  HeaderWeatherView.swift
//  JHAlarm
//
//  Created by 김제현 on 30/09/2019.
//  Copyright © 2019 김제현. All rights reserved.
//

import Foundation
import RxCocoa
import RxSwift
import Kingfisher

class HeaderWeatherView: UIView {
//    private var disposeBag = DisposeBag()
    @IBOutlet var lbWeather: UILabel!
    @IBOutlet var ivWeather: UIImageView!

    var viewModel: HeaderWeatherVM!
    
    
    func configure() {
        lbWeather.text = viewModel.weatherText
        ivWeather.kf.setImage(with: viewModel.imgWeatherURL)
        self.backgroundColor = COLOR_DARK_BG_LIST
//        viewModel.weatherText.errorOnEmpty()
//            .bind(to: lbWeather.rx.text)
//            .disposed(by: disposeBag)
//        viewModel.imgWeatherURL.filterNil()
//            .subscribe ( onNext: { [weak self] in
//                if let _self = self {
//                    _self.ivWeather.kf.setImage(with: $0)
//                }
//        }).disposed(by: disposeBag)
    }
}
