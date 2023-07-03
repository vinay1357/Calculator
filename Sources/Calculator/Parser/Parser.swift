//
//  Parser.swift
//  Assignment_Calculator
//
//  Created by vinay kamra on 27/06/23.
//

import Foundation

public protocol CalculatorParserProtocol {
    func parseString(rawValue: String) throws -> Double
}

public class RegularExpressionParser: CalculatorParserProtocol {
    public func parseString(rawValue: String) throws -> Double {
        let tokenizer = Tokenizer(input: rawValue)
        let parser = try Parser(tokenizer: tokenizer)
        return try parser.parse()
    }
    
    public init() {}

}

enum TokenType {
    case number
    case plus
    case minus
    case multiply
    case divide
    case end
}

// Define the Token struct
struct Token {
    
    let type: TokenType
    let value: String
    let decimalPoint: Int
    
    init (type: TokenType, value: String, decimalPoint: Int = 0) {
        self.type = type
        self.value = value
        self.decimalPoint = decimalPoint
    }
}

// Define the Tokenizer to tokenize the input expression
class Tokenizer {
    let input: String
    var position: String.Index
    var maxDecimalPrecision: Int = 0
    public var valueWithDecimal: Bool = false

    init(input: String) {
        self.input = input
        self.position = input.startIndex
    }

    func getNextToken() throws -> Token {
        var decimalPoint = 0
        var isDecimalNumber = false
        guard position < input.endIndex else {
            return Token(type: .end, value: "")
        }

        let currentChar = input[position]
        switch currentChar {
        case "0"..."9", ".":
            var number = String(currentChar)
            position = input.index(after: position)
            while position < input.endIndex {
                let digit = input[position]
                if  digit.isNumber || digit == "." {
                    
                    if isDecimalNumber && digit == "." {
                        throw ParserError.inValidExpression(input:"Multiple . in the expression \(input)")
                    }
                    number.append(digit)
                    position = input.index(after: position)
                    if isDecimalNumber {
                        decimalPoint += 1
                    }
                    if (digit == ".") {
                        isDecimalNumber = true
                        valueWithDecimal = true
                    }
                } else {
                    maxDecimalPrecision = max(decimalPoint, maxDecimalPrecision)
                    break
                }
                
            }
            return Token(type: .number, value: number, decimalPoint: decimalPoint)
        case "+":
            position = input.index(after: position)
            return Token(type: .plus, value: "+")
        case "-":
            position = input.index(after: position)
            return Token(type: .minus, value: "-")
        case "*":
            position = input.index(after: position)
            return Token(type: .multiply, value: "*")
        case "/":
            position = input.index(after: position)
            return Token(type: .divide, value: "/")
        default:
            throw ParserError.nonSupportedOperator(input: "No supportive operator in input \(input)")
        }
    }
}

// Define the Parser to parse and evaluate the expression
class Parser {
    let tokenizer: Tokenizer
    var currentToken: Token
    var isDecimalNumer: Bool = false

    init(tokenizer: Tokenizer) throws {
        self.tokenizer = tokenizer
        self.currentToken = try tokenizer.getNextToken()
    }

    // Helper method to match the expected token type
    func eat(_ expectedType: TokenType) throws {
        if currentToken.type == expectedType {
            currentToken = try tokenizer.getNextToken()
        } else {
            throw ParserError.invalidNumber(input: currentToken.value)
        }
    }

    // Recursive descent expression parsing
    func factor() throws -> Double  {
        let token = currentToken
        switch token.type {
        case .number:
            try eat(.number)
            return token.value.toDouble(withDecimal: token.decimalPoint) ?? 0.0
        default:
            throw ParserError.invalidNumber(input: token.value)
        }
    }

    func term() throws -> Double {
        var result:Double = try factor()

        while currentToken.type == .multiply || currentToken.type == .divide {
            let token = currentToken
            if token.type == .multiply {
                try eat(.multiply)
                result *= try factor()
            } else if token.type == .divide {
                try eat(.divide)
                 let value = try factor()
                guard value != 0 else {
                    throw ParserError.divideByZero
                }
                result =  result / value

            }
        }

        return result
    }

    func expr() throws -> Double {
        var result = try term()

        while currentToken.type == .plus || currentToken.type == .minus {
            let token = currentToken
            if token.type == .plus {
                try eat(.plus)
                result += try term()

            } else if token.type == .minus {
                try eat(.minus)
                result -= try term()
            }
        }

        return result
    }

    func parse() throws -> Double {
        return try expr()
    }
}
