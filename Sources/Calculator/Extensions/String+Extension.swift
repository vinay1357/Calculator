//
//  String+Extension.swift
//  Assignment_Calculator
//
//  Created by vinay kamra on 29/06/23.
//

import Foundation

extension String {
    public func toDouble(withDecimal: Int) -> Double? {
        if withDecimal == 0 {
            return NumberFormatter().number(from: self)?.doubleValue
        } else {
            return Double(self) ?? 0.0
        }
    }
}
