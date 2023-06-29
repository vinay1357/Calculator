//
//  NetwrokError.swift
//  Assignment_Calculator
//
//  Created by vinay kamra on 29/06/23.
//

import Foundation
enum NetworkError: Error {
    case invalidURL
    case invalidServerResponse
    case apiError
    case connectivityError
}
