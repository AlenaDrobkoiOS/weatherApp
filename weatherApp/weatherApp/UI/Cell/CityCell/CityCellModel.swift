//
//  CityCellModel.swift
//  weatherApp
//
//  Created by Alena Drobko on 07.10.23.
//

import Foundation
import RxSwift
import RxCocoa

/// City cell data model
final class CityCellModel: ReactiveCompatible {
    let title: String?
    let isButtonsVisible: Bool
    
    fileprivate let historyTapEvent = PublishSubject<Void>()
    fileprivate let detailsTapEvent = PublishSubject<Void>()
    
    init(title: String?, isButtonsVisible: Bool) {
        self.title = title
        self.isButtonsVisible = isButtonsVisible
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

extension Reactive where Base: CityCellModel {
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
