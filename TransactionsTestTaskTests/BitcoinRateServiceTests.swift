//
//  BitcoinRateServiceTests.swift
//  TransactionsTestTask
//
//  Created by Oleh Veheria on 08.01.2025.
//

import XCTest
@testable import TransactionsTestTask

final class BitcoinRateServiceTests: XCTestCase {

    var bitcoinRateService: BitcoinRateServiceImpl!
    var mockCoreDataManager: MockCoreDataManager!
    var mockAnalyticsService: MockAnalyticsService!

    override func setUp() {
        super.setUp()
        mockCoreDataManager = MockCoreDataManager()
        mockAnalyticsService = MockAnalyticsService()
        bitcoinRateService = BitcoinRateServiceImpl(
            analyticsService: mockAnalyticsService,
            coreDataManager: mockCoreDataManager
        )
    }

    override func tearDown() {
        bitcoinRateService.stopFetching()
        bitcoinRateService = nil
        mockCoreDataManager = nil
        mockAnalyticsService = nil
        super.tearDown()
    }

    func testFetchBitcoinRate() {
        // Arrange
        let expectation = self.expectation(description: "Fetch Bitcoin Rate")
        bitcoinRateService.onRateUpdate = { rate in
            XCTAssertEqual(rate, 45000.5)
            expectation.fulfill()
        }

        // Act
        bitcoinRateService.startFetching(interval: 1)

        // Assert
        waitForExpectations(timeout: 5, handler: nil)
    }

    func testGetCachedRate() {
        // Arrange
        let rate = 45000.5
        mockCoreDataManager.saveBitcoinRate(rate: rate, timestamp: Date())

        // Act
        let cachedRate = bitcoinRateService.getCachedRate()

        // Assert
        XCTAssertEqual(cachedRate, rate)
    }
}
