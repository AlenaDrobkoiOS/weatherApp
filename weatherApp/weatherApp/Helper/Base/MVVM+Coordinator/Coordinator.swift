//
//  Coordinator.swift
//  weatherApp
//
//  Created by Alena Drobko on 07.10.2023.
//

import Foundation
import RxSwift
import RxCocoa

///Base protocol for all coordinators
class Coordinator<ResultType>: NSObject, DeinitLoggerType {
    
    typealias CoordinationResult = ResultType
    
    let disposeBag = DisposeBag()
    
    private let identifier = UUID()
    private var childCoordinators = [UUID: Any]()
    
    override init() {
        super.init()
        setupDeinitAnnouncer()
    }

    private func store<T>(coordinator: Coordinator<T>) {
        childCoordinators[coordinator.identifier] = coordinator
    }

    private func free<T>(coordinator: Coordinator<T>) {
        childCoordinators[coordinator.identifier] = nil
    }

    @discardableResult // ignore return value
    func coordinate<T>(to coordinator: Coordinator<T>) -> Observable<T> {
        store(coordinator: coordinator)
        return coordinator.start()
            .withUnretained(coordinator)
            .do(onNext: { [weak self] coordinator, _ in
                self?.free(coordinator: coordinator)
            }).map { $0.1 }
    }

    func start() -> Observable<ResultType> {
        fatalError("Start method should be implemented.")
    }
}

extension Coordinator {
    func freeAllChildCoordinators() {
        childCoordinators = [:]
    }
}
