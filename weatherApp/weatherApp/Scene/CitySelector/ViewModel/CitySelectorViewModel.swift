//
//  CitySelectorViewModel.swift
//  weatherApp
//
//  Created by Alena Drobko on 07.10.23.
//

import Foundation
import RxSwift
import RxCocoa

/// CitySelector screen view model
final class CitySelectorViewModel: BaseCitySelectorViewModel {
    private let bag = DisposeBag()
    
    private let synchronizationSerice: SynchronizationSericeType
    
    private var cities: [City] = [] {
        didSet {
            tableItems.accept(
                cities.map({ info in
                    let model = CityCellModel(title: info.name + ", " + info.country,
                                              isButtonsVisible: true)
                    model.detailsTapObservable()
                        .bind(onNext: { [weak self] _ in
                            self?.openDetails.onNext((city: info, historicalInfo: nil))
                        })
                        .disposed(by: bag)
                    model.historyTapObservable()
                        .bind(onNext: { [weak self] _ in
                            self?.openHistory.onNext(info)
                        })
                        .disposed(by: bag)
                    return model
                }))
        }
    }
    
    private let headerInfo = BehaviorRelay<HeaderInfo>(value: .init())
    private var tableItems: BehaviorRelay<[CityCellModel]> = BehaviorRelay<[CityCellModel]>(value: [])
    private let isLoading = BehaviorRelay<Bool>(value: true)
    
    override init(injections: Injections) {
        synchronizationSerice = injections.serviceHolder.get(by: SynchronizationSericeType.self)
        
        super.init(injections: injections)
        
        fetchCities()
    }
    
    private func fetchCities() {
        isLoading.accept(true)
        
        synchronizationSerice.getCities { list in
            self.cities = list?.map({ $0.city }) ?? []
            self.isLoading.accept(false)
        }
    }
    
    override func transform(_ input: Input, outputHandler: @escaping (Output) -> Void) {
        input.disposeBag.insert([
            setUpReload(with: reload),
            setUpAddTapped(with: input.addTapped),
            setUpCitySelected(with: input.citySelected)
        ])
        
        let output = Output(
            tableItems: tableItems.asDriver(),
            isLoading: isLoading.asObservable()
        )
        outputHandler(output)
    }
    
    private func setUpAddTapped(with signal: Observable<Void>) -> Disposable {
        signal
            .bind(onNext: { [weak self] value in
                self?.openSearch.onNext(value)
            })
    }
    
    private func setUpReload(with signal: Observable<Void>) -> Disposable {
        signal
            .bind(onNext: { [weak self] value in
                self?.fetchCities()
            })
    }
    
    private func setUpCitySelected(with signal: Observable<IndexPath>) -> Disposable {
        signal
            .bind(onNext: { [weak self] value in
                guard let self = self else { return }
                
                if value.row < self.cities.count {
                    self.openDetails.onNext((city:self.cities[value.row], historicalInfo: nil))
                }
            })
    }
}
