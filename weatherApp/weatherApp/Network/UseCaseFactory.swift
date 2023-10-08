//
//  UseCaseFactory.swift
//  weatherApp
//
//  Created by Alena Drobko on 08.10.2023.
//

import Foundation

struct UseCaseFactory {
    static func makeWeatherUseCase() -> WeatherUseCaseType {
        return WeatherUseCase(baseUrl: Constants.baseURL, authProvider: ApiKeyProvider.shared)
    }
}
