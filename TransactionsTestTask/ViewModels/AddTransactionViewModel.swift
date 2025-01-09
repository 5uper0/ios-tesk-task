//
//  AddTransactionViewModel.swift
//  TransactionsTestTask
//
//  Created by Oleh Veheria on 08.01.2025.
//

import Foundation

final class AddTransactionViewModel {

    private let coreDataManager: CoreDataManager

    init(coreDataManager: CoreDataManager) {
        self.coreDataManager = coreDataManager
    }

    func addTransaction(amount: Double, category: TransactionCategory) {
        coreDataManager.saveTransaction(id: UUID(), amount: amount, category: category, date: Date(), type: .expense)
        NotificationCenter.default.post(name: .transactionAdded, object: nil)
    }
}

extension Notification.Name {
    static let transactionAdded = Notification.Name("transactionAdded")
}
