//
//  MockCoreDataManager.swift
//  TransactionsTestTask
//
//  Created by Oleh Veheria on 08.01.2025.
//

import Foundation
import CoreData
@testable import TransactionsTestTask

final class MockCoreDataManager: CoreDataManager {
    private let persistentContainer: NSPersistentContainer
    private var context: NSManagedObjectContext {
        return persistentContainer.viewContext
    }

    init() {
        persistentContainer = NSPersistentContainer(name: "TransactionsTestTask")
        let description = NSPersistentStoreDescription()
        description.type = NSInMemoryStoreType // Use in-memory store for testing
        persistentContainer.persistentStoreDescriptions = [description]

        persistentContainer.loadPersistentStores { _, error in
            if let error = error {
                fatalError("Failed to set up in-memory store: \(error)")
            }
        }
    }

    func saveTransaction(id: UUID, amount: Double, category: TransactionCategory, date: Date, type: TransactionType) {
        let transaction = Transaction(context: context)
        transaction.id = id
        transaction.amount = amount
        transaction.category = category.rawValue
        transaction.date = date
        transaction.type = type.rawValue
        saveContext()
    }

    func fetchTransactions(limit: Int? = nil) -> [Transaction] {
        let fetchRequest: NSFetchRequest<Transaction> = Transaction.fetchRequest()
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "date", ascending: false)]
        if let limit = limit {
            fetchRequest.fetchLimit = limit
        }
        do {
            return try context.fetch(fetchRequest)
        } catch {
            Logger.logError("Failed to fetch transactions: \(error)")
            return []
        }
    }

    func saveBitcoinRate(rate: Double, timestamp: Date) {
        let bitcoinRate = BitcoinRate(context: context)
        bitcoinRate.rate = rate
        bitcoinRate.timestamp = timestamp
        saveContext()
    }

    func fetchBitcoinRate() -> Double? {
        let fetchRequest: NSFetchRequest<BitcoinRate> = BitcoinRate.fetchRequest()
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "timestamp", ascending: false)]
        fetchRequest.fetchLimit = 1
        do {
            return try context.fetch(fetchRequest).first?.rate
        } catch {
            Logger.logError("Failed to fetch bitcoin rate: \(error)")
            return nil
        }
    }

    func getBalance() -> Double {
        let fetchRequest: NSFetchRequest<Transaction> = Transaction.fetchRequest()
        do {
            let transactions = try context.fetch(fetchRequest)
            let income = transactions
                .filter { $0.type == TransactionType.income.rawValue }
                .reduce(0) { $0 + $1.amount }
            let spending = transactions
                .filter { $0.type == TransactionType.expense.rawValue }
                .reduce(0) { $0 + $1.amount }
            return income - spending
        } catch {
            Logger.logError("Failed to fetch transactions for balance: \(error)")
            return 0.0
        }
    }

    private func saveContext() {
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                Logger.logError("Failed to save context: \(error)")
            }
        }
    }
}
