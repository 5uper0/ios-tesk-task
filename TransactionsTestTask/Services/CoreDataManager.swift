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
    func saveTransaction(
        id: UUID,
        amount: Double,
        category: TransactionCategory,
        date: Date,
        type: TransactionType
    )
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
    func saveContext() {
        guard context.hasChanges else { return }
        do {
            try context.save()
        } catch {
            Logger.logError("Core Data save error: \(error)")
        }
    }

    func saveTransaction(
        id: UUID,
        amount: Double,
        category: TransactionCategory,
        date: Date,
        type: TransactionType
    ) {
        let transaction = Transaction(context: context)
        transaction.id = id
        transaction.amount = amount
        transaction.category = category.rawValue
        transaction.date = date
        transaction.type = type.rawValue
        saveContext()
    }

    func fetchTransactions(limit: Int?) -> [Transaction] {
        let request: NSFetchRequest<Transaction> = Transaction.fetchRequest()
        request.sortDescriptors = [NSSortDescriptor(key: "date", ascending: false)]
        if let limit = limit {
            request.fetchLimit = limit
        }
        do {
            return try context.fetch(request)
        } catch {
            Logger.logError("Failed to fetch transactions: \(error)")
            return []
        }
    }

    func getBalance() -> Double {
        // Tally up all 'income' minus 'spending' in the database
        let request: NSFetchRequest<Transaction> = Transaction.fetchRequest()
        do {
            let transactions = try context.fetch(request)
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
}
