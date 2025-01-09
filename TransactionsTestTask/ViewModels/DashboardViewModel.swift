//
//  DashboardViewModel.swift
//  TransactionsTestTask
//
//  Created by Oleh Veheria on 08.01.2025.
//

import Foundation
import Combine

final class DashboardViewModel {

    @Published private(set) var balance: Double = 0.0
    @Published private(set) var groupedTransactions: [String: [Transaction]] = [:]
    @Published private(set) var bitcoinRate: Double = 0.0

    private let coreDataManager: CoreDataManager
    private let bitcoinRateService: BitcoinRateService
    private var cancellables = Set<AnyCancellable>()
    private var allTransactions: [Transaction] = []
    private var currentPage = 0
    private let pageSize = 20

    init(coreDataManager: CoreDataManager, bitcoinRateService: BitcoinRateService) {
        self.coreDataManager = coreDataManager
        self.bitcoinRateService = bitcoinRateService
        fetchBitcoinRate()
        fetchTransactionsAndUpdateBalance()
    }

    func fetchTransactionsAndUpdateBalance() {
        allTransactions = coreDataManager.fetchTransactions(limit: nil)
        currentPage = 0
        groupedTransactions = [:]
        loadMoreTransactions()
        balance = coreDataManager.getBalance()
    }

    func loadMoreTransactions() {
        let startIndex = currentPage * pageSize
        let endIndex = min(startIndex + pageSize, allTransactions.count)
        guard startIndex < endIndex else { return }

        let transactionsToAdd = Array(allTransactions[startIndex..<endIndex])
        let grouped = Dictionary(grouping: transactionsToAdd) { transaction -> String in
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd"
            return dateFormatter.string(from: transaction.date ?? Date())
        }

        for (key, value) in grouped {
            if groupedTransactions[key] != nil {
                groupedTransactions[key]?.append(contentsOf: value)
            } else {
                groupedTransactions[key] = value
            }
        }

        currentPage += 1
    }

    func addTransaction(amount: Double, category: TransactionCategory) {
        coreDataManager.saveTransaction(id: UUID(), amount: amount, category: category, date: Date(), type: .expense)
        fetchTransactionsAndUpdateBalance()
    }

    func fetchBitcoinRate() {
        bitcoinRateService.onRateUpdate = { [weak self] rate in
            self?.bitcoinRate = rate
        }
        bitcoinRateService.startFetching(interval: 120)
    }

    func topUpBalance(amount: Double) {
        coreDataManager.saveTransaction(id: UUID(), amount: amount, category: .other, date: Date(), type: .income)
        fetchTransactionsAndUpdateBalance()
    }
}
