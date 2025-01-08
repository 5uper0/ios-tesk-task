//
//  CoreDataManagerTests.swift
//  TransactionsTestTask
//
//  Created by Oleh Veheria on 07.01.2025.
//

import CoreData
import XCTest
@testable import TransactionsTestTask

final class CoreDataManagerTests: XCTestCase {

    var mockCoreDataManager: MockCoreDataManager!

    override func setUp() {
        super.setUp()
        mockCoreDataManager = MockCoreDataManager()
    }

    override func tearDown() {
        mockCoreDataManager = nil
        super.tearDown()
    }

    func testMockSaveAndFetchTransactions() {
        // Arrange
        let transactionID = UUID()
        let amount = 100.0
        let category = "Groceries"
        let date = Date()
        let type = "Expense"

        // Act
        mockCoreDataManager.saveTransaction(
            id: transactionID,
            amount: amount,
            category: category,
            date: date,
            type: type
        )
        let transactions = mockCoreDataManager.fetchTransactions()

        // Assert
        XCTAssertEqual(transactions.count, 1)
        XCTAssertEqual(transactions.first?.id, transactionID)
        XCTAssertEqual(transactions.first?.amount, amount)
        XCTAssertEqual(transactions.first?.category, category)
        XCTAssertEqual(transactions.first?.type, type)
    }

    func testMockSaveAndFetchBitcoinRate() {
        // Arrange
        let rate = 45000.5

        // Act
        mockCoreDataManager.saveBitcoinRate(rate: rate, timestamp: Date())
        let fetchedRate = mockCoreDataManager.fetchBitcoinRate()

        // Assert
        XCTAssertEqual(fetchedRate, rate)
    }

    func testCoreDataManagerImplAdheresToProtocol() {
        // Arrange
        let coreDataManager: CoreDataManager = CoreDataManagerImpl.shared
        let transactionID = UUID()
        let amount = 100.0
        let category = "Groceries"
        let date = Date()
        let type = "Expense"

        // Act
        coreDataManager.saveTransaction(
            id: transactionID,
            amount: amount,
            category: category,
            date: date,
            type: type
        )
        let transactions = coreDataManager.fetchTransactions(limit: 1)

        // Assert
        XCTAssertEqual(transactions.count, 1)
        XCTAssertEqual(transactions.first?.id, transactionID)
        XCTAssertEqual(transactions.first?.amount, amount)
        XCTAssertEqual(transactions.first?.category, category)
        XCTAssertEqual(transactions.first?.type, type)
    }
}
