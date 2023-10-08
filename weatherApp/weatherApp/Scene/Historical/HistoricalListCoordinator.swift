//
//  HistoricalListCoordinator.swift
//  weatherApp
//
//  Created by Alena Drobko on 07.10.23.
//

import UIKit
import RxSwift

/// Historical screen coordinator result - dismiss
enum HistoricalCoordinatorResult {
    case dismiss
}

/// Historical screen coordinator
final class HistoricalCoordinator: Coordinator<HistoricalCoordinatorResult> {
    struct Injections {
        let navigationController: UINavigationController
        let serviceHolder: ServiceHolder
        let city: City
    }
    
    private let navigationController: UINavigationController
    private let serviceHolder: ServiceHolder
    private let city: City
    
    init(injections: Injections) {
        navigationController = injections.navigationController
        serviceHolder = injections.serviceHolder
        city = injections.city
    }
    
    override func start() -> Observable<HistoricalCoordinatorResult> {
        let viewModel = HistoricalViewModel(injections: .init(serviceHolder: serviceHolder, city: city))
        let controller = HistoricalViewController(viewModel: viewModel)
        
        navigationController.pushViewController(controller, animated: true)
        
        viewModel.openDetails
            .flatMap { value in
                self.openDetails(with: value)
            }
            .bind { result in
                switch result {
                case .dismiss:
                    print("Details screen dismissed")
                }
            }
            .disposed(by: disposeBag)
        
        return viewModel.dismiss
            .do(onNext: { [weak self] in
                self?.navigationController.popViewController(animated: true)
            })
            .map { _ in
                return HistoricalCoordinatorResult.dismiss
            }
    }
    
    private func openDetails(with info: (city: City, historicalInfo: HistoricalInfo)) -> Observable<WeatherDetailCoordinatorResult> {
        let coordinator = WeatherDetailCoordinator(injections:
                .init(navigationController: navigationController,
                      serviceHolder: serviceHolder,
                      city: info.city,
                      historyInfo: info.historicalInfo))
        return coordinate(to: coordinator)
    }
}

