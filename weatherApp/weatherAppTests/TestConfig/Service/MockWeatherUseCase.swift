//
//  MockWeatherUseCase.swift
//  weatherAppTests
//
//  Created by Alena Drobko on 08.10.23.
//

import Foundation
import RxSwift
@testable import weatherApp

class MockWeatherUseCase: WeatherUseCaseType {
    func getWeather(_ city: String) -> Single<WeatherResponce> {
        // Mock weather data for testing
        let weather = Weather(id: 800, main: "Clear", description: "Clear Sky", icon: "01d")
        let main = Main(temp: 25.0, feelsLike: 26.0, pressure: 1010.0, humidity: 60.0, tempMin: 24.0, tempMax: 26.0)
        let wind = Wind(speed: 5.0, degrees: 180.0, gust: 8.0)
        let clouds = Clouds(cloudiness: 10.0)
        
        let response = WeatherResponce(
            cod: CodeValue.success(200),
            message: "OK",
            coord: Coord(lon: 0.0, lat: 0.0),
            weather: [weather],
            base: "stations",
            main: main,
            visibility: 10000.0,
            wind: wind,
            clouds: clouds,
            rain: nil,
            snow: nil,
            dt: 1635348000,
            sys: System(type: 1, id: 1234, message: "message", country: "US",
                        sunrise: 1635300000, sunset: 1635340000),
            timezone: -25200,
            id: 123456,
            name: "City1"
        )
        
        return Single.just(response)
    }
}
