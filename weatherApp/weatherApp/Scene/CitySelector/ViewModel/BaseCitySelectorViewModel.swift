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
        let disposeBag: DisposeBag
    }
    
    internal struct Output {
        let tableItems: Driver<[CitySelectorCellModel]>
        let isLoading: Observable<Bool>
    }
    
    public var openDetails = PublishSubject<City>()
    public var openHistory = PublishSubject<City>()
    public var openSearch = PublishSubject<Void>()
    
    init(injections: Injections) {}
    
    func transform(_ input: Input, outputHandler: @escaping (Output) -> Void) {}
}
