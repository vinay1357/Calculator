//
//  MarketModel.swift
//  Assignment_Calculator
//
//  Created by vinay kamra on 28/06/23.
//

import Foundation

struct MarketModel: Codable {
    let success: Bool
    let timestamp: Int
    let target: String
    let rates: [String: Double]
}
