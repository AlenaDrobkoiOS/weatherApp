//
//  BaseWeatherDetailViewModel.swift
//  weatherApp
//
//  Created by Alena Drobko on 07.10.23.
//

import Foundation
import Foundation
import RxSwift
import RxCocoa

/// WeatherDetail screen base view model
class BaseWeatherDetailViewModel: ViewModelProtocol {
    
    struct Injections {
        let serviceHolder: ServiceHolder
        let city: City
    }
    
    internal struct Input {
        let dismissTapped: Observable<Void>
        let dismissed: Observable<Void>
        let disposeBag: DisposeBag
    }
    
    internal struct Output {
        let headerInfo: Observable<HeaderInfo>
        let detailInfo: Observable<WeatherDetailInfoViewModel>
        let footerInfo: Observable<FooterViewInfo>
        let isLoading: Observable<Bool>
    }
    
    public var dismissTapped = PublishSubject<Void>()
    public var dismissed = PublishSubject<Void>()
    
    init(injections: Injections) {}
    
    func transform(_ input: Input, outputHandler: @escaping (Output) -> Void) {}
}
