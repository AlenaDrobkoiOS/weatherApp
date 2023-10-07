//
//  SearchCoordinator.swift
//  weatherApp
//
//  Created by Alena Drobko on 07.10.23.
//

import Foundation
import UIKit
import RxSwift

/// Search screen coordinator result: details or dismiss
enum SearchCoordinatorResult {
    case details(City)
    case dismiss
}

/// Search screen coordinator
final class SearchCoordinator: Coordinator<SearchCoordinatorResult> {
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
    
    override func start() -> Observable<SearchCoordinatorResult> {
        let viewModel = SearchViewModel(injections:
                .init(serviceHolder: serviceHolder))
        let controller = SearchViewController(viewModel: viewModel)
        
        navigationController.present(controller, animated: true)
        
        let openDetailsEvent = viewModel.openDetails
            .map { city in
                return SearchCoordinatorResult.details(city)
            }
        
        let dismissEvent = viewModel.dismissed
            .map { city in
                return SearchCoordinatorResult.dismiss
            }
        
        return Observable.merge([openDetailsEvent, dismissEvent]).take(1)
    }
}
