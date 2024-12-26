//
//  PortfolioCalculatorTest.swift
//  AkshayShedgeTaskTests
//
//  Created by Akshay Shedge on 26/12/24.
//

import XCTest

// Mock model for UserHoldin
final class PortfolioCalculatorTests: XCTestCase {

    var sut: PortfolioCalculator.Type!

    override func setUp() {
        super.setUp()
        sut = PortfolioCalculator.self
    }

    override func tearDown() {
        sut = nil
        super.tearDown()
    }
    
    
     func testCalculateCurrentValue() {
         let userHoldings: [UserHolding] = [
            UserHolding(symbol: "test", quantity: 10, ltp: 100.0, avgPrice: 50.0, close: 95.0),
            UserHolding(symbol: "test", quantity: 5, ltp: 150.0, avgPrice: 120.0, close: 145.0)
         ]
         
         let result = sut.calculateCurrentValue(from: userHoldings)
         
         let expectedResult: Double = (100.0 * 10) + (150.0 * 5)
         XCTAssertEqual(result, expectedResult, "Calculated current value is incorrect.")
     }

     func testCalculateTotalInvestment() {
         let userHoldings: [UserHolding] = [
            UserHolding(symbol: "Test", quantity: 10, ltp: 100.0, avgPrice: 50.0, close: 95.0),
            UserHolding(symbol: "test", quantity: 5, ltp: 150.0, avgPrice: 120.0, close: 145.0)
         ]
         
         let result = sut.calculateTotalInvestment(from: userHoldings)
         
         let expectedResult: Double = (50.0 * 10) + (120.0 * 5)
         XCTAssertEqual(result, expectedResult, "Calculated total investment is incorrect.")
     }

    func testCalculateTodaysPNL() {
         let userHoldings: [UserHolding] = [
            UserHolding(symbol: "test", quantity: 10, ltp: 100.0, avgPrice: 50.0, close: 95.0),
            UserHolding(symbol: "test", quantity: 5, ltp: 150.0, avgPrice: 120.0, close: 145.0)
         ]
         
         let result = sut.calculateTodaysPNL(from: userHoldings)
         
        // let expectedResult: Double = ((95.0 - 100.0) * 10) + ((145.0 - 150.0) * 5)
        let expectedResult: Double = -75.0
         XCTAssertEqual(result, expectedResult, "Calculated today's PNL is incorrect.")
     }

     func testCalculateTotalPNL() {
         let currentValue: Double = 2000.0
         let totalInvestment: Double = 1800.0
         
         let result = sut.calculateTotalPNL(currentValue: currentValue, totalInvestment: totalInvestment)
         
         let expectedResult: Double = 2000.0 - 1800.0
         XCTAssertEqual(result, expectedResult, "Calculated total PNL is incorrect.")
     }

     func testCalculateTotalPNLPercentage() {
         let totalPNL: Double = 200.0
         let totalInvestment: Double = 1800.0
         
         let result = sut.calculateTotalPNLPercentage(totalPNL: totalPNL, totalInvestment: totalInvestment)
         
         let expectedResult: Double = (200.0 / 1800.0) * 100
         XCTAssertEqual(result, expectedResult, accuracy: 0.01, "Calculated total PNL percentage is incorrect.")
     }
    
    func testCalculateProfitAndLoss() {
        let userHolding = UserHolding(symbol: "test", quantity: 10, ltp: 120.0, avgPrice: 200.0, close: nil)
        let result = sut.calculateProfitAndLoss(from: userHolding)
        XCTAssertEqual(result, -800.0)
    }
    
    func testDetermineTradeType() {
        let userHolding = UserHolding(symbol: "test", quantity: 10, ltp: 120.0, avgPrice: 200.0, close: nil)
        let result = sut.determineTradeType(from: userHolding)
        XCTAssertEqual(result, .loss)
    }
}
