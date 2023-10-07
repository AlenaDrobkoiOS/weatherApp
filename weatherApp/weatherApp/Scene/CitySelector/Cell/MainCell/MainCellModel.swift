//
//  CitySelectorCellModel.swift
//  weatherApp
//
//  Created by Alena Drobko on 07.10.23.
//

import Foundation
import RxSwift
import RxCocoa

/// CitySelector screen cell data model
final class CitySelectorCellModel: ReactiveCompatible {
    let title: String?
    
    fileprivate let historyTapEvent = PublishSubject<Void>()
    fileprivate let detailsTapEvent = PublishSubject<Void>()
    
    init(title: String?) {
        self.title = title
    }
    
    init(data: City) {
        self.title = data.name
    }
    
    // MARK: - View Model Output
    
    func historyTapObservable() -> Observable<Void> {
        return historyTapEvent.asObservable()
    }
    
    func detailsTapObservable() -> Observable<Void> {
        return detailsTapEvent.asObservable()
    }
}

// MARK: - Reactive Ext

extension Reactive where Base: CitySelectorCellModel {
    var historyTapEvent: Binder<Void> {
        return Binder(base) { base, _ in
            base.historyTapEvent.onNext(())
        }
    }
    
    var detailsTapEvent: Binder<Void> {
        return Binder(base) { base, _ in
            base.detailsTapEvent.onNext(())
        }
    }
}
