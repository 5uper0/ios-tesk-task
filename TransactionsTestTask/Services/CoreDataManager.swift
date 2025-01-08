//
//  CoreDataManager.swift
//  TransactionsTestTask
//
//  Created by Oleh Veheria on 06.01.2025.
//

import CoreData
import Foundation

/// Protocol for CoreData operations
protocol CoreDataManager {
    func saveTransaction(id: UUID, amount: Double, category: TransactionCategory, date: Date, type: TransactionType)
    func fetchTransactions(limit: Int?) -> [Transaction]
    func saveBitcoinRate(rate: Double, timestamp: Date)
    func fetchBitcoinRate() -> Double?
    func getBalance() -> Double
}

final class CoreDataManagerImpl: CoreDataManager {

    // MARK: - Singleton Instance
    static let shared = CoreDataManagerImpl()
    private init() {}

    // MARK: - Core Data Stack
    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "TransactionsTestTask")
        container.loadPersistentStores { _, error in
            if let error = error as NSError? {
                Logger.logError("Core Data Store Loading Failed: \(error), \(error.userInfo)")
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        }
        return container
    }()

    var context: NSManagedObjectContext {
        return persistentContainer.viewContext
    }

    // MARK: - CRUD Operations
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
            let balance = transactions.reduce(0.0) { result, transaction in
                return result + (transaction.type == TransactionType.income.rawValue ? transaction.amount : -transaction.amount)
            }
            return balance
        } catch {
            Logger.logError("Failed to fetch transactions for balance calculation: \(error)")
            return 0.0
        }
    }

    private func saveContext() {
        if context.hasChanges {
            do {
                try context.save()
                Logger.logDebug("Context saved successfully.")
            } catch {
                let nserror = error as NSError
                Logger.logError("Failed to save context: \(nserror), \(nserror.userInfo)")
            }
        }
    }
}
