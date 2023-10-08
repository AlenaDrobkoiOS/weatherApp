//
//  SearchViewModel.swift
//  weatherApp
//
//  Created by Alena Drobko on 07.10.23.
//

import Foundation
import RxSwift
import RxCocoa

/// Search screen view model
final class SearchViewModel: BaseSearchViewModel {
    private let bag = DisposeBag()
    
    private let weatherUseCase: WeatherUseCaseType
    private let synchronizationSerice: SynchronizationSericeType
    private let alertService: AlertServiceType
    
    private var cities: [CityInfo] = [] {
        didSet {
            tableItems.accept( cities.map({
                CityCellModel(title: $0.city.name + ", " + $0.city.country,
                              isButtonsVisible: false) }))
        }
    }
    
    private var tableItems: BehaviorRelay<[CityCellModel]> = BehaviorRelay<[CityCellModel]>(value: [])
    private let isLoading = BehaviorRelay<Bool>(value: false)
    
    override init(injections: Injections) {
        weatherUseCase = injections.serviceHolder.get(by: WeatherUseCaseType.self)
        alertService = injections.serviceHolder.get(by: AlertServiceType.self)
        synchronizationSerice = injections.serviceHolder.get(by: SynchronizationSericeType.self)
        
        super.init(injections: injections)
    }
    
    private func searchCities(with text: String?) {
        guard let text = text, !text.isEmpty else {
            cities = []
            return
        }
        
        isLoading.accept(true)
        weatherUseCase.getWeather(text)
            .subscribe(onSuccess: { [weak self] element in
                let info = CityInfo(responce: element)
                
                self?.synchronizationSerice.addCityInfo(info) {
                    self?.cities = [info]
                    self?.isLoading.accept(false)
                }
            }, onFailure: { [weak self] error in
                self?.isLoading.accept(false)
                self?.alertService.show.onNext(.error(error))
            })
            .disposed(by: bag)
    }
    
    override func transform(_ input: Input, outputHandler: @escaping (Output) -> Void) {
        input.disposeBag.insert([
            setUpTextUpdated(with: input.textUpdated),
            setUpCancelTapped(with: input.cancelTapped),
            setUpCitySelected(with: input.citySelected),
            setUpDismissed(with: input.dismissed)
        ])
        
        let output = Output(
            tableItems: tableItems.asDriver(),
            isLoading: isLoading.asObservable()
        )
        outputHandler(output)
    }
    
    private func setUpCancelTapped(with signal: Observable<Void>) -> Disposable {
        signal
            .bind(onNext: { [weak self] value in
                self?.searchCities(with: "")
            })
    }
    
    private func setUpCitySelected(with signal: Observable<IndexPath>) -> Disposable {
        signal
            .bind(onNext: { [weak self] value in
                guard let self = self else { return }
                
                if value.row < self.cities.count {
                    self.openDetails.onNext((city: self.cities[value.row].city,
                                             historicalInfo: self.cities[value.row].history?.first))
                }
            })
    }
    
    private func setUpTextUpdated(with signal: Observable<String?>) -> Disposable {
        signal
            .bind(onNext: { [weak self] value in
                self?.searchCities(with: value)
            })
    }
    
    private func setUpDismissed(with signal: Observable<Void>) -> Disposable {
        signal
            .bind(onNext: { [weak self] value in
                self?.dismissed.onNext(value)
            })
    }
}
