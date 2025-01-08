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
    func saveTransaction(id: UUID, amount: Double, category: String, date: Date, type: String)
    func fetchTransactions(limit: Int?) -> [Transaction]
    func saveBitcoinRate(rate: Double, timestamp: Date)
    func fetchBitcoinRate() -> Double?
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
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        }
        return container
    }()

    var context: NSManagedObjectContext {
        return persistentContainer.viewContext
    }

    // MARK: - CRUD Operations
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
            print("Failed to fetch transactions: \(error)")
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
            print("Failed to fetch bitcoin rate: \(error)")
            return nil
        }
    }

    private func saveContext() {
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nserror = error as NSError
                print("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
}
