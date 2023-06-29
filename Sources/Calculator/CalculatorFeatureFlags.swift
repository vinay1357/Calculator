//
//  CalculatorFeatureFlags.swift
//  Assignment_Calculator
//
//  Created by VinayKamra on 27/06/23.
//

import Foundation


// MARK: - CalculatorFeatureFlags
public struct CalculatorFeatureFlags: Codable {
    let calculator: Calculator
}

// MARK: - Calculator
public struct Calculator: Codable {
    let showPlusOperatorr, showMinusOperator, showMultiplyOperator, showDivisionOperator: Bool
    let showEqualOperator, showSinOperator, showCosOperator, showOnlineOperator: Bool
}

extension CalculatorFeatureFlags {
    
    public static var featureFlags:CalculatorFeatureFlags {
        loadJson(fileName:"FeatureFlags")!
    }
    
    private static func loadJson(fileName: String) -> CalculatorFeatureFlags? {
        guard let url  = Bundle.module.url(forResource: fileName, withExtension: "json") else {
            return nil
        }
        do {
            let decoder = JSONDecoder()
            let data = try Data(contentsOf: url)
            
            return try decoder.decode(CalculatorFeatureFlags.self, from: data)
        }
        catch {
            print(error)
        }
        return nil
    }
}
