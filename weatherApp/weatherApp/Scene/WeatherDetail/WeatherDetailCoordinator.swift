//
//  WeatherDetailCoordinator.swift
//  weatherApp
//
//  Created by Alena Drobko on 07.10.23.
//

import Foundation
import UIKit
import RxSwift

/// WeatherDetail screen coordinator result - dismiss
enum WeatherDetailCoordinatorResult {
    case dismiss
}

/// WeatherDetail screen coordinator
final class WeatherDetailCoordinator: Coordinator<WeatherDetailCoordinatorResult> {
    struct Injections {
        let navigationController: UINavigationController
        let serviceHolder: ServiceHolder
        let city: City
    }
    
    private let navigationController: UINavigationController
    private let serviceHolder: ServiceHolder
    private let city: City
    
    init(injections: Injections) {
        self.navigationController = injections.navigationController
        self.serviceHolder = injections.serviceHolder
        self.city = injections.city
    }
    
    override func start() -> Observable<WeatherDetailCoordinatorResult> {
        let viewModel = WeatherDetailViewModel(injections:
                .init(serviceHolder: serviceHolder, city: city))
        let controller = WeatherDetailViewController(viewModel: viewModel)
        
        navigationController.present(controller, animated: true)
        
        let dismissEvent = viewModel.dismissTapped
            .do(onDispose:  {
                controller.dismiss(animated: true)
            })
            .map { city in
                return WeatherDetailCoordinatorResult.dismiss
            }

        
        let dismissedEvent = viewModel.dismissed
            .map { city in
                return WeatherDetailCoordinatorResult.dismiss
            }
        
        return Observable.merge([dismissedEvent, dismissEvent]).take(1)
    }
}
