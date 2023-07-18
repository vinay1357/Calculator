//
//  CalculatorOperationUtility.swift
//  Assignment_Calculator
//
//  Created by vinay kamra on 28/06/23.
//

import Foundation
import CalculatorUIComponent

class CalculatorOperationUtility {
    static func getTrigoValueforButtonType(buttonType: CalculatorButton, rawValue: String) throws -> Double? {
        switch  buttonType {
        case .sin:
            guard let double = Double(rawValue) else {
                throw ConversionError.notANumber
            }
            return sin(double.deg2rad())            
        case .cos:
            guard let double = Double(rawValue) else {
                throw ConversionError.notANumber
            }
            return cos(double.deg2rad())
        default:
            throw ConversionError.notANumber
        }
    }
}
