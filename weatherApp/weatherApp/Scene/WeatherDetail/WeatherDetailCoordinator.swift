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
        let historyInfo: HistoricalInfo?
        
        init(navigationController: UINavigationController, serviceHolder: ServiceHolder,
             city: City, historyInfo: HistoricalInfo? = nil) {
            self.navigationController = navigationController
            self.serviceHolder = serviceHolder
            self.city = city
            self.historyInfo = historyInfo
        }
    }
    
    private let navigationController: UINavigationController
    private let serviceHolder: ServiceHolder
    private let city: City
    private let historyInfo: HistoricalInfo?
    
    init(injections: Injections) {
        navigationController = injections.navigationController
        serviceHolder = injections.serviceHolder
        city = injections.city
        historyInfo = injections.historyInfo
    }
    
    override func start() -> Observable<WeatherDetailCoordinatorResult> {
        let viewModel = WeatherDetailViewModel(injections:
                .init(serviceHolder: serviceHolder, city: city, historyInfo: historyInfo))
        let controller = WeatherDetailViewController(viewModel: viewModel)
        
        navigationController.present(controller, animated: true)
        
        let dismissEvent = viewModel.dismissTapped
            .do(onNext: { 
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
