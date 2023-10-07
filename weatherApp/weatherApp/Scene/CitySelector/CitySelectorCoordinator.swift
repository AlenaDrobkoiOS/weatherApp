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
        self.navigationController = injections.navigationController
        self.serviceHolder = injections.serviceHolder
    }
    
    @discardableResult // ignore return value
    override func start() -> Observable<Void> {
        let viewModel = CitySelectorViewModel(injections: .init(serviceHolder: serviceHolder))
        let controller = CitySelectorViewController(viewModel: viewModel)
        
        navigationController.pushViewController(controller, animated: false)
        
        viewModel.openSearch
            .flatMap { _ in
                self.openSearch()
            }
            .bind { result in
                switch result {
                case .dismiss:
                    print("Details screen dismissed")
                case .details(let city):
                    viewModel.openDetails.onNext(city)
                }
            }
            .disposed(by: disposeBag)
        
        viewModel.openDetails
            .flatMap { city in
                self.openDetails(with: city)
            }
            .bind { result in
                //                switch result {
                //                case .dismiss:
                //                    print("Details screen dismissed")
                //                }
            }
            .disposed(by: disposeBag)
        
        return .never()
    }
    
    private func openHistory(with city: City) -> Observable<Void> {
        return .just(())
    }
    
    private func openDetails(with city: City) -> Observable<Void> {
        return .just(())
    }
    
    private func openSearch() -> Observable<SearchCoordinatorResult> {
        let coordinator = SearchCoordinator(injections:
                .init(navigationController: navigationController,
                      serviceHolder: serviceHolder))
        return coordinate(to: coordinator)
    }
}
