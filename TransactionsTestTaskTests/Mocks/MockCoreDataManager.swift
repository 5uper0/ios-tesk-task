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

    func saveTransaction(id: UUID, amount: Double, category: String, date: Date, type: String) {
        let transaction = Transaction(context: context)
        transaction.id = id
        transaction.amount = amount
        transaction.category = category
        transaction.date = date
        transaction.type = type
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
