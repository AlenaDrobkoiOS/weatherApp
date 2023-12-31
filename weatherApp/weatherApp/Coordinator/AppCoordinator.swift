//
//  AppCoordinator.swift
//  weatherApp
//
//  Created by Alena Drobko on 07.10.2023.
//

import UIKit
import RxSwift

/// General App Coordinator
final class AppCoordinator: Coordinator<Void> {
    
    struct Injections {
        let window: UIWindow
    }
    
    private let window: UIWindow
    
    private var navigationController = UINavigationController()
    private var dataController = DataController(completionClosure: {})
    private var serviceHolder = ServiceHolder()
    
    init(injections: Injections) {
        self.window = injections.window
        super.init()
    }
    
    @discardableResult // ignore return value
    override func start() -> Observable<Void> {
        setUp()
        coordinateToMain()
        return .never()
    }
    
    private func setUp() {
        setUpNC()
        setUpServices()
        startCoreData()
    }
    
    private func coordinateToMain() {
        let mainCoordinator = CitySelectorCoordinator(injections: .init(navigationController: navigationController,
                                                                serviceHolder: serviceHolder))
       coordinate(to: mainCoordinator)
    }
    
    /// Set up navigation controller
    private func setUpNC() {
        navigationController.navigationBar.barTintColor = .white
        navigationController.setNavigationBarHidden(true, animated: false)
        
        window.rootViewController = navigationController
        window.makeKeyAndVisible()
    }
    
    /// Init some services, add services to service holder
    private func setUpServices() {
        let weatherUseCase = UseCaseFactory.makeWeatherUseCase()
        serviceHolder.add(WeatherUseCaseType.self, for: weatherUseCase)
        
        let alertService = AlertService()
        serviceHolder.add(AlertServiceType.self, for: alertService)
    }
    
    private func startCoreData() {
        let historyActivityDAO = GenericDAO<HistoricalInfo, WeatherInfoCREntity>(context: dataController.backgroundContext)
        let cityDAO = CityModelDAO(context: dataController.backgroundContext,
                                   historyDAO: historyActivityDAO)
        let syncService = SynchronizationSerice(historyActivityDAO: historyActivityDAO,
                                                cityDAO: cityDAO)
        serviceHolder.add(SynchronizationSericeType.self, for: syncService)
    }
}
