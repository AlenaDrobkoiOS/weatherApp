//
//  TestConfiguration.swift
//  weatherAppTests
//
//  Created by Alena Drobko on 08.10.23.
//

import UIKit
import RxSwift
@testable import weatherApp

class TestConfiguration {
    static func getServiceHolder() -> ServiceHolder {
        let serviceHolder = ServiceHolder()
        
        let mockSynchronizationService = MockSynchronizationService()
        serviceHolder.add(SynchronizationSericeType.self, for: mockSynchronizationService)
        
        let mockWeatherUseCase = MockWeatherUseCase()
        serviceHolder.add(WeatherUseCaseType.self, for: mockWeatherUseCase)
        
        let mockAlertService = MockAlertService()
        serviceHolder.add(AlertServiceType.self, for: mockAlertService)
        
        return serviceHolder
    }
}
