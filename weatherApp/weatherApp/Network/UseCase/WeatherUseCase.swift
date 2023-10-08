//
//  WeatherUseCase.swift
//  weatherApp
//
//  Created by Alena Drobko on 08.10.2023.
//

import RxSwift

/// WeatherUseCase service protocol
protocol WeatherUseCaseType: Service {
    func getWeather(_ city: String) -> Single<WeatherResponce>
}

/// WeatherUseCase - trigger Weather requests
final class WeatherUseCase: NetworkProvider<WeatherEndpoints>, WeatherUseCaseType {
    func getWeather(_ city: String) -> Single<WeatherResponce> {
        let model = BaseRequestDataModel(sendData: WeatherRequestData(city: city,
                                                                      appid: authProvider.token() ?? "",
                                                                      mode: Constants.mode,
                                                                      units: Constants.units,
                                                                      lang: Constants.lang),
                                         baseUrl: baseUrl)
        return request(endpoint: .getWeather(requestData: model))
    }
}
