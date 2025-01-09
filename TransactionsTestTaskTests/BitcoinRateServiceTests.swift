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

        // Mock URLSession to return a predefined response
        let mockURLSession = MockURLSession()
        mockURLSession.data = """
        {
            "time": {
                "updated": "Jan 8, 2025 00:03:00 UTC",
                "updatedISO": "2025-01-08T00:03:00+00:00"
            },
            "bpi": {
                "USD": {
                    "code": "USD",
                    "rate": "45,000.5",
                    "rate_float": 45000.5
                }
            }
        }
        """.data(using: .utf8)

        // Inject the mock URLSession into the BitcoinRateService
        bitcoinRateService.urlSession = mockURLSession

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

    func testAnalyticsEventTracking() {
        // Arrange
        let expectation = self.expectation(description: "Track Analytics Event")
        bitcoinRateService.onRateUpdate = { _ in
            let events = self.mockAnalyticsService.getEvents(name: "bitcoin_rate_update", dateRange: nil)
            XCTAssertEqual(events.count, 1)
            XCTAssertEqual(events.first?.name, "bitcoin_rate_update")
            expectation.fulfill()
        }

        // Mock URLSession to return a predefined response
        let mockURLSession = MockURLSession()
        mockURLSession.data = """
        {
            "time": {
                "updated": "Jan 8, 2025 00:03:00 UTC",
                "updatedISO": "2025-01-08T00:03:00+00:00"
            },
            "bpi": {
                "USD": {
                    "code": "USD",
                    "rate": "45,000.5",
                    "rate_float": 45000.5
                }
            }
        }
        """.data(using: .utf8)

        // Inject the mock URLSession into the BitcoinRateService
        bitcoinRateService.urlSession = mockURLSession

        // Act
        bitcoinRateService.startFetching(interval: 1)

        // Assert
        waitForExpectations(timeout: 5, handler: nil)
    }
}
