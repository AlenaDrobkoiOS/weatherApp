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
    
    private let weatherUseCase: WeatherUseCaseType
    private let synchronizationSerice: SynchronizationSericeType
    private let alertService: AlertServiceType
    
    private var city: City
    
    private let isLoading = BehaviorRelay<Bool>(value: false)
    private let headerInfo = BehaviorRelay<HeaderInfo>(value: .init())
    private let footerInfo = BehaviorRelay<FooterViewInfo>(value: .init())
    private let detailInfo = BehaviorRelay<WeatherDetailInfoViewModel>(value: .init())
    
    override init(injections: Injections) {
        city = injections.city
        
        weatherUseCase = injections.serviceHolder.get(by: WeatherUseCaseType.self)
        alertService = injections.serviceHolder.get(by: AlertServiceType.self)
        synchronizationSerice = injections.serviceHolder.get(by: SynchronizationSericeType.self)
        
        super.init(injections: injections)
        
        headerInfo.accept(.init(title: city.name + " " + city.country,
                                leftButtonState: .modal))
        
        if let historyInfo = injections.historyInfo {
            footerInfo.accept(.init(city: city.name,
                                    date: historyInfo.date))
            detailInfo.accept(historyInfo.weatherInfo)
        } else {
            footerInfo.accept(.init(city: city.name, date: Date()))
            loadWeatherDetail()
        }
    }
    
    private func loadWeatherDetail() {
        isLoading.accept(true)
        
        weatherUseCase.getWeather(city.name)
            .subscribe(onSuccess: { [weak self] element in
                let info = CityInfo(responce: element)
                
                self?.synchronizationSerice.addCityInfo(info) {
                    if let info = info.history?.first {
                        self?.detailInfo.accept(info.weatherInfo)
                        self?.isLoading.accept(false)
                    }
                }
            }, onFailure: { [weak self] error in
                self?.isLoading.accept(false)
                self?.alertService.show.onNext(.error(error))
            })
            .disposed(by: bag)
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
