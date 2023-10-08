//
//  HistoricalListViewModel.swift
//  weatherApp
//
//  Created by Alena Drobko on 07.10.23.
//

import Foundation
import RxSwift
import RxCocoa

/// Historical screen view model
final class HistoricalViewModel: BaseHistoricalViewModel {
    private let bag = DisposeBag()
    
    private let synchronizationSerice: SynchronizationSericeType
    
    private let city: City
    private var info: [HistoricalInfo] = [] {
        didSet {
            tableItems.accept(info)
        }
    }
    
    private let headerInfo = BehaviorRelay<HeaderInfo>(value: .init())
    private var tableItems: BehaviorRelay<[HistoricalInfo]> = BehaviorRelay<[HistoricalInfo]>(value: [])
    private let isLoading = BehaviorRelay<Bool>(value: true)
    
    override init(injections: Injections) {
        city = injections.city
        synchronizationSerice = injections.serviceHolder.get(by: SynchronizationSericeType.self)
        
        super.init(injections: injections)
        
        headerInfo.accept(.init(title: city.name + "\n" + Localizationable.Global.historical.localized,
                                leftButtonState: .left))
        fetchHistory()
    }
    
    private func fetchHistory() {
        isLoading.accept(true)
        synchronizationSerice.getCityHistory(for: city) { [weak self] history in
            self?.info = history ?? []
            self?.isLoading.accept(false)
        }
    }
    
    override func transform(_ input: Input, outputHandler: @escaping (Output) -> Void) {
        input.disposeBag.insert([
            setUpDismiss(with: input.backTapped),
            setUpItemSelected(with: input.itemSelected)
        ])
        
        let output = Output(
            headerInfo: headerInfo.asObservable(),
            tableItems: tableItems.asDriver(),
            isLoading: isLoading.asObservable()
        )
        outputHandler(output)
    }
    
    private func setUpDismiss(with signal: Observable<Void>) -> Disposable {
        signal
            .bind(onNext: { [weak self] value in
                self?.dismiss.onNext(value)
            })
    }
    
    private func setUpItemSelected(with signal: Observable<IndexPath>) -> Disposable {
        signal
            .bind(onNext: { [weak self] value in
                guard let self = self else { return }
                
                if value.row < info.count {
                    self.openDetails.onNext((city: city, historicalInfo: info[value.row]))
                }
            })
    }
}
