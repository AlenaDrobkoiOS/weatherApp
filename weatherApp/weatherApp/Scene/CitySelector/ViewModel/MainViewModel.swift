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
    
    private var cities: [City] = [] {
        didSet {
            tableItems.accept(
                cities.map( { CitySelectorCellModel(data: $0) }))
        }
    }
    
    private var tableItems: BehaviorRelay<[CitySelectorCellModel]> = BehaviorRelay<[CitySelectorCellModel]>(value: [])
    private let isLoading = BehaviorRelay<Bool>(value: true)
    
    override init(injections: Injections) {
        super.init(injections: injections)
        
        fetchCities()
    }
    
    private func fetchCities() {
        isLoading.accept(true)
        cities = [.init(id: "", name: "TEST, IOS")]
        isLoading.accept(false)
    }
    
    override func transform(_ input: Input, outputHandler: @escaping (Output) -> Void) {
        input.disposeBag.insert([
            setUpAddTapped(with: input.addTapped)
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
}
