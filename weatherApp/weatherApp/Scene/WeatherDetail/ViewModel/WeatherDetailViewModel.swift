//
//  WeatherDetailViewModel.swift
//  weatherApp
//
//  Created by Alena Drobko on 07.10.23.
//

import Foundation
import RxSwift
import RxCocoa

/// WeatherDetail screen view model
final class WeatherDetailViewModel: BaseWeatherDetailViewModel {
    private let bag = DisposeBag()
    
    private var city: City
    
    private let isLoading = BehaviorRelay<Bool>(value: false)
    private let headerInfo = BehaviorRelay<HeaderInfo>(value: .init())
    private let footerInfo = BehaviorRelay<FooterViewInfo>(value: .init())
    private let detailInfo = BehaviorRelay<WeatherDetailInfoViewModel>(value: .init())
    
    override init(injections: Injections) {
        city = injections.city
        
        super.init(injections: injections)
        
        if let historyInfo = injections.historyInfo {
            headerInfo.accept(.init(title: city.name,
                                    leftButtonState: .modal))
            footerInfo.accept(.init(city: city.name,
                                    date: historyInfo.date))
            detailInfo.accept(historyInfo.weatherInfo)
        } else {
            loadWeatherDetail()
            
            headerInfo.accept(.init(title: city.name,
                                    leftButtonState: .modal))
            footerInfo.accept(.init(city: city.name, date: Date()))
        }
    }
    
    private func loadWeatherDetail() {
        isLoading.accept(true)
        detailInfo.accept(.init(iconURL: "",
                                description: "test", windSpeeped: "34",
                                humidity: "35", temperature: "36"))
        isLoading.accept(false)
    }
    
    override func transform(_ input: Input, outputHandler: @escaping (Output) -> Void) {
        input.disposeBag.insert([
            setUpDismissTapped(with: input.dismissTapped),
            setUpDismissed(with: input.dismissed)
        ])
        
        let output = Output(headerInfo: headerInfo.asObservable(),
                            detailInfo: detailInfo.asObservable(),
                            footerInfo: footerInfo.asObservable(),
                            isLoading: isLoading.asObservable())
        outputHandler(output)
    }
    
    private func setUpDismissTapped(with signal: Observable<Void>) -> Disposable {
        signal
            .bind(onNext: { [weak self] value in
                self?.dismissTapped.onNext(value)
            })
    }
    
    private func setUpDismissed(with signal: Observable<Void>) -> Disposable {
        signal
            .bind(onNext: { [weak self] value in
                self?.dismissed.onNext(value)
            })
    }
}
