//
//  BaseCitySelectorViewModel.swift
//  weatherApp
//
//  Created by Alena Drobko on 07.10.23.
//

import Foundation
import RxSwift
import RxCocoa

/// CitySelector screen base view model
class BaseCitySelectorViewModel: ViewModelProtocol {
    
    struct Injections {
        let serviceHolder: ServiceHolder
    }
    
    internal struct Input {
        let addTapped: Observable<Void>
        let citySelected: Observable<IndexPath>
        let disposeBag: DisposeBag
    }
    
    internal struct Output {
        let tableItems: Driver<[CityCellModel]>
        let isLoading: Observable<Bool>
    }
    
    public let openDetails = PublishSubject<(city: City, historicalInfo: HistoricalInfo?)>()
    public let openHistory = PublishSubject<City>()
    public let openSearch = PublishSubject<Void>()
    
    public let reload = PublishSubject<Void>()
    
    init(injections: Injections) {}
    
    func transform(_ input: Input, outputHandler: @escaping (Output) -> Void) {}
}
