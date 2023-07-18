//
//  Assignment_CalculatorTests.swift
//  Assignment_CalculatorTests
//
//  Created by VinayKamra on 27/06/23.
//

import XCTest
@testable import Calculator

final class Assignment_CalculatorTests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExample() throws {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        // Any test you write for XCTest can be annotated as throws and async.
        // Mark your test throws to produce an unexpected failure when your test encounters an uncaught error.
        // Mark your test async to allow awaiting for asynchronous code to complete. Check the results with assertions afterwards.
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
    func testGetTrigoValueForSin() {
            do {
                let result = try CalculatorOperationUtility.getTrigoValueforButtonType(buttonType: .sin, rawValue: "90")
                XCTAssertEqual(result!, 1, accuracy: 0.0001)
            } catch {
                XCTFail("Error: \(error)")
            }
        }

        func testGetTrigoValueForCos() {
            do {
                let result = try CalculatorOperationUtility.getTrigoValueforButtonType(buttonType: .cos, rawValue: "0")
                XCTAssertEqual(result!, 1, accuracy: 0.0001)
            } catch {
                XCTFail("Error: \(error)")
            }
        }

        func testGetTrigoValueForInvalidNumberThrowsError() {
            XCTAssertThrowsError(try CalculatorOperationUtility.getTrigoValueforButtonType(buttonType: .sin, rawValue: "abc")) { error in
                XCTAssertEqual(error as? ConversionError, ConversionError.notANumber)
            }
        }
    
    func testGetTrigoCosValueForInvalidNumberThrowsError() {
        XCTAssertThrowsError(try CalculatorOperationUtility.getTrigoValueforButtonType(buttonType: .cos, rawValue: "abc")) { error in
            XCTAssertEqual(error as? ConversionError, ConversionError.notANumber)
        }
    }


}
