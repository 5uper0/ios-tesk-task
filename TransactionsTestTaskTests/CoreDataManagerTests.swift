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
        let category = TransactionCategory.groceries.rawValue
        let date = Date()
        let type = TransactionType.expense.rawValue

        // Act
        mockCoreDataManager.saveTransaction(
            id: transactionID,
            amount: amount,
            category: .groceries,
            date: date,
            type: .expense
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
        let category = TransactionCategory.groceries.rawValue
        let date = Date()
        let type = TransactionType.expense.rawValue

        // Act
        coreDataManager.saveTransaction(
            id: transactionID,
            amount: amount,
            category: .groceries,
            date: date,
            type: .expense
        )
        let transactions = coreDataManager.fetchTransactions(limit: 1)

        // Assert
        XCTAssertEqual(transactions.count, 1)
        XCTAssertEqual(transactions.first?.id, transactionID)
        XCTAssertEqual(transactions.first?.amount, amount)
        XCTAssertEqual(transactions.first?.category, category)
        XCTAssertEqual(transactions.first?.type, type)
    }

    func testGetBalance() {
        // Arrange
        let incomeTransactionID = UUID()
        let expenseTransactionID = UUID()
        let incomeAmount = 200.0
        let expenseAmount = 50.0
        let category = TransactionCategory.other.rawValue
        let date = Date()

        // Act
        mockCoreDataManager.saveTransaction(
            id: incomeTransactionID,
            amount: incomeAmount,
            category: .other,
            date: date,
            type: .income
        )
        mockCoreDataManager.saveTransaction(
            id: expenseTransactionID,
            amount: expenseAmount,
            category: .other,
            date: date,
            type: .expense
        )
        let balance = mockCoreDataManager.getBalance()

        // Assert
        XCTAssertEqual(balance, incomeAmount - expenseAmount)
    }
}
