//
//  CitySelectorCoordinator.swift
//  weatherApp
//
//  Created by Alena Drobko on 07.10.23.
//

import UIKit
import RxSwift

/// CitySelector screen coordinator
final class CitySelectorCoordinator: Coordinator<Void> {
    struct Injections {
        let navigationController: UINavigationController
        let serviceHolder: ServiceHolder
    }
    
    private let navigationController: UINavigationController
    private let serviceHolder: ServiceHolder
    
    init(injections: Injections) {
        navigationController = injections.navigationController
        serviceHolder = injections.serviceHolder
    }
    
    @discardableResult // ignore return value
    override func start() -> Observable<Void> {
        let viewModel = CitySelectorViewModel(injections: .init(serviceHolder: serviceHolder))
        let controller = CitySelectorViewController(viewModel: viewModel)
        
        navigationController.pushViewController(controller, animated: false)
        
        viewModel.openHistory
            .flatMap { city in
                self.openHistory(with: city)
            }
            .bind { result in
                switch result {
                case .dismiss:
                    print("History screen dismissed")
                }
            }
            .disposed(by: disposeBag)
        
        viewModel.openSearch
            .flatMap { _ in
                self.openSearch()
            }
            .bind { result in
                switch result {
                case .dismiss:
                    print("Search screen dismissed")
                case .details(let city):
                    self.navigationController.visibleViewController?.dismiss(animated: true) {
                        viewModel.openDetails.onNext(city)
                    }
                }
            }
            .disposed(by: disposeBag)
        
        viewModel.openDetails
            .flatMap { city in
                self.openDetails(with: city)
            }
            .bind { result in
                switch result {
                case .dismiss:
                    print("Details screen dismissed")
                }
            }
            .disposed(by: disposeBag)
        
        return .never()
    }
    
    private func openHistory(with city: City) -> Observable<HistoricalCoordinatorResult> {
        let coordinator = HistoricalCoordinator(injections:
                .init(navigationController: navigationController,
                      serviceHolder: serviceHolder,
                      city: city))
        return coordinate(to: coordinator)
    }
    
    private func openDetails(with city: City) -> Observable<WeatherDetailCoordinatorResult> {
        let coordinator = WeatherDetailCoordinator(injections:
                .init(navigationController: navigationController,
                      serviceHolder: serviceHolder,
                      city: city))
        return coordinate(to: coordinator)
    }
    
    private func openSearch() -> Observable<SearchCoordinatorResult> {
        let coordinator = SearchCoordinator(injections:
                .init(navigationController: navigationController,
                      serviceHolder: serviceHolder))
        return coordinate(to: coordinator)
    }
}
