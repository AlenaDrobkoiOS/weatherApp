//
//  NetworkProvider.swift
//  weatherApp
//
//  Created by Alena Drobko on 08.10.2023.
//

import Moya
import RxSwift

/// Network Provider - use MoyaProvider and trigger request
class NetworkProvider<EndpointType: TargetType> {
    let provider = MoyaProvider<EndpointType>()
    
    let baseUrl: URL
    let authProvider: AuthorizationTokenProvider
    
    init(baseUrl: URL, authProvider: AuthorizationTokenProvider) {
        self.baseUrl = baseUrl
        self.authProvider = authProvider
    }
    
    internal func request<T>(endpoint: EndpointType) -> Single<T> where T: BaseResponseProtocol {
        return provider.rx.request(endpoint)
            .flatMap { response in
                return Single.just(response)
                    .map(T.self, using: JSONDecoder())
            }
            .checkServerError()
    }
}
