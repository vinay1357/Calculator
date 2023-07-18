//
//  NetworkApiManager.swift
//  Assignment_Calculator
//
//  Created by vinay kamra on 28/06/23.
//

import Foundation

protocol NetworkApiManagerProtocol {
    func perform<T: Decodable>(_ request: RequestProtocol) async throws -> T
}

final class CoinLayerNetworkApiManager: NetworkApiManagerProtocol {
    private let urlSession: URLSession
    private let networkRechability: NetworkReachability = NetworkReachability.shared
    private var baseUrl: String {
        return "api.coinlayer.com"
    }
    private var accesskey: String {
        return "06121d407c19293dda11731ea366c986"
    }
    init(urlSession: URLSession = URLSession.shared) {
        self.urlSession = urlSession
    }

    func perform<T: Decodable>(_ request: RequestProtocol) async throws -> T
    {
        if networkRechability.connectivityStatus != .connected {
            throw NetworkError.connectivityError
        }
        
        let (data, response) = try await urlSession.data(
            for: request.createURLRequest(baseUrl: baseUrl, accessKey: accesskey)
        )
        
        guard let httpResponse = response as? HTTPURLResponse else {
            throw NetworkError.invalidServerResponse
        }
        
        if httpResponse.statusCode == 200 {
            let responseObject: T = try JSONDecoder().decode(T.self, from: data)
            return responseObject
            
        } else {
            throw NetworkError.apiError
        }
    }
}
