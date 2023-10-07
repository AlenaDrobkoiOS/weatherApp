//
//  BaseSearchViewModel.swift
//  weatherApp
//
//  Created by Alena Drobko on 07.10.23.
//

import Foundation
import Foundation
import RxSwift
import RxCocoa

/// Search screen base view model
class BaseSearchViewModel: ViewModelProtocol {
    
    struct Injections {
        let serviceHolder: ServiceHolder
    }
    
    internal struct Input {
        let cancelTapped: Observable<Void>
        let citySelected: Observable<IndexPath>
        let textUpdated: Observable<String?>
        let dismissed: Observable<Void>
        let disposeBag: DisposeBag
    }
    
    internal struct Output {
        let tableItems: Driver<[CityCellModel]>
        let isLoading: Observable<Bool>
    }
    
    public var openDetails = PublishSubject<City>()
    public var dismissed = PublishSubject<Void>()
    
    init(injections: Injections) {}
    
    func transform(_ input: Input, outputHandler: @escaping (Output) -> Void) {}
}
