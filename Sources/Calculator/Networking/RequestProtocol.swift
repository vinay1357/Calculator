//
//  RequestProtocol.swift
//  Assignment_Calculator
//
//  Created by vinay kamra on 28/06/23.
//

import Foundation

enum RequestType: String {
    case GET
    case PUT
}

protocol RequestProtocol {
    var path: String { get }
    var headers: [String: String] { get }
    var params: [String: Any] { get }
    var urlParams: [String: String?] { get }
    var requestType: RequestType { get }
    
    func createURLRequest(baseUrl: String, accessKey: String) throws -> URLRequest
}

extension RequestProtocol {
    
    var params: [String: Any] { [:] }
    var urlParams: [String: String?] { [:] }
    var headers: [String: String] { [:] }
    
    func createURLRequest(baseUrl: String, accessKey: String) throws -> URLRequest {
        
        var components = URLComponents()
        components.scheme = "http"
        components.host = baseUrl
        components.path = self.path
        
        if !accessKey.isEmpty {
            components.queryItems = [URLQueryItem(name:"access_key", value: accessKey)]
        }
        
        if !urlParams.isEmpty {
            components.queryItems = urlParams.map {
                URLQueryItem(name: $0, value: $1)
            }
            components.percentEncodedQuery = components.percentEncodedQuery?.replacingOccurrences(of: "+", with: "%2B")
        }
        
        guard let url = components.url else { throw NetworkError.invalidURL }
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = requestType.rawValue
        
        if !headers.isEmpty {
            urlRequest.allHTTPHeaderFields = headers
        }
        
        urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let body = params
        if !body.isEmpty {
            urlRequest.httpBody = try JSONSerialization.data(withJSONObject: body)
        }
        return urlRequest
    }
}
