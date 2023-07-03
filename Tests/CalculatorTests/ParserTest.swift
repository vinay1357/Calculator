//
//  ParserTest.swift
//  Assignment_CalculatorTests
//
//  Created by vinay kamra on 29/06/23.
//

import XCTest
@testable import Calculator

final class ParserTest: XCTestCase {
    var parser: RegularExpressionParser!

    override func setUpWithError() throws {
         try super.setUpWithError()
        parser = RegularExpressionParser()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    func testRegularExpressionParsingAndEvaluation() {
        do {
            let result = try parser.parseString(rawValue: "3+3*5+9.0+6.0")
            XCTAssertEqual(result, 33.0, accuracy: 0.0001)
        } catch {
            XCTFail("Error: \(error)")
        }
    }

    func testInvalidExpressionThrowsError() {
        XCTAssertThrowsError(try parser.parseString(rawValue: "3+3*+5+9.0+6.0")) { error in
            XCTAssertNil(error, "Error can't be nil")
        }
    }

    func testExpressionWithDecimals() {
        do {
            let result = try parser.parseString(rawValue: "3.1+2.4")
            XCTAssertEqual(result, 5.5, accuracy: 0.0001)
        } catch {
            XCTFail("Error: \(error)")
        }
    }

    func testExpressionWithZeroDivisionThrowsError() {
        XCTAssertThrowsError(try parser.parseString(rawValue: "5/0")) { error in
            XCTAssertNil(error, "Error can't be nil")
        }
    }

    func testExpressionWithNegativeNumbers() {
        do {
            let result = try parser.parseString(rawValue: "3-2*4")
            XCTAssertEqual(result, -5.0, accuracy: 0.0001)
        } catch {
            XCTFail("Error: \(error)")
        }
    }

    func testExpressionWithMaxDecimalPrecision() {
        do {
            let result = try parser.parseString(rawValue: "2.111+3.2222")
            XCTAssertEqual(result, 5.3333, accuracy: 0.0001)
        } catch {
            XCTFail("Error: \(error)")
        }
    }
}
