//
//  Double+Extension.swift
//  Assignment_Calculator
//
//  Created by vinay kamra on 29/06/23.
//

import Foundation

extension Double {
    var clean: String {
        return self.truncatingRemainder(dividingBy: 1) == 0 ? String(format: "%.0f", self) : String(self)
    }
    
    func deg2rad() -> Double {
        return self * .pi / 180
    }
}
