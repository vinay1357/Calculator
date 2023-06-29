//
//  ParsorError.swift
//  Assignment_Calculator
//
//  Created by vinay kamra on 29/06/23.
//

import Foundation

public enum ParserError :Error {
    case invalidNumber
    case inValidExpression
    case divideByZero
    case nonSupportedOperator
}
