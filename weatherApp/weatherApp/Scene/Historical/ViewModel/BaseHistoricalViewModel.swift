//
//  BaseHistoricalViewModel.swift
//  weatherApp
//
//  Created by Alena Drobko on 07.10.23.
//

import Foundation
import RxSwift
import RxCocoa

/// Historical screen base view model
class BaseHistoricalViewModel: ViewModelProtocol {
    
    struct Injections {
        let serviceHolder: ServiceHolder
        let city: City
    }
    
    internal struct Input {
        let backTapped: Observable<Void>
        let itemSelected: Observable<IndexPath>
        let disposeBag: DisposeBag
    }
    
    internal struct Output {
        let headerInfo: Observable<HeaderInfo>
        let tableItems: Driver<[HistoricalInfo]>
        let isLoading: Observable<Bool>
    }
    
    public var openDetails = PublishSubject<(city: City, historicalInfo: HistoricalInfo)>()
    public var dismiss = PublishSubject<Void>()
    
    init(injections: Injections) {}
    
    func transform(_ input: Input, outputHandler: @escaping (Output) -> Void) {}
}
