//
//  WeatherEndpoints.swift
//  weatherApp
//
//  Created by Alena Drobko on 08.10.2023.
//

import Moya

/// Weather requests enpoints
enum WeatherEndpoints: TargetType {
    case getWeather(requestData: RequestModelTypeProtocol)

    private var extractedRequestData: RequestModelTypeProtocol {
        switch self {
        case .getWeather(let requestData):
            return requestData
        }
    }
}

extension WeatherEndpoints{
    var baseURL: URL {
        extractedRequestData.baseUrl
    }

    var path: String {
        switch self {
        case .getWeather:
            return "/data/2.5/weather"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .getWeather:
            return .get
        }
    }
    
    var task: Task {
        guard let parameters = extractedRequestData.parameters else {
            return .requestPlain
        }
        
        switch self {
        case .getWeather:
            return .requestParameters(parameters: parameters, encoding: URLEncoding.default)
        }
    }
    
    var headers: [String: String]? {
        return nil
    }
}
