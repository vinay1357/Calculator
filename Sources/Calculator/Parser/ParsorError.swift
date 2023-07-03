//
//  ParsorError.swift
//  Assignment_Calculator
//
//  Created by vinay kamra on 29/06/23.
//

import Foundation

public enum ParserError :Error {
    case invalidNumber(input: String)
    case inValidExpression(input: String)
    case divideByZero
    case nonSupportedOperator(input: String)
    
    var description: String {
        switch(self) {
        case let .invalidNumber(input):
            return "Invalid Number \(input), Only valid number is allowed for this operation."
            
        case let .inValidExpression(input):
            return "Invalid expression, Reason: \(input)"
            
        case .divideByZero:
            return "Can't be divide by zero"
            
        case .nonSupportedOperator(input: let input):
            return "Non Supportive operator, Reason: \(input)"
        }
    }
}
