//
//  DashboardViewModel.swift
//  TransactionsTestTask
//
//  Created by Oleh Veheria on 08.01.2025.
//

import Foundation
import Combine

class DashboardViewModel {

    @Published private(set) var balance: Double = 0.0
    @Published private(set) var transactions: [Transaction] = []
    @Published private(set) var bitcoinRate: Double = 0.0

    private let coreDataManager: CoreDataManager
    private let bitcoinRateService: BitcoinRateService
    private var cancellables = Set<AnyCancellable>()

    init(coreDataManager: CoreDataManager, bitcoinRateService: BitcoinRateService) {
        self.coreDataManager = coreDataManager
        self.bitcoinRateService = bitcoinRateService
        fetchTransactions()
        fetchBitcoinRate()
        updateBalance()
    }

    func fetchTransactions() {
        transactions = coreDataManager.fetchTransactions(limit: 20)
    }

    func topUpBalance(amount: Double) {
        coreDataManager.saveTransaction(id: UUID(), amount: amount, category: .other, date: Date(), type: .income)
        fetchTransactions()
        updateBalance()
    }

    func fetchBitcoinRate() {
        bitcoinRateService.onRateUpdate = { [weak self] rate in
            self?.bitcoinRate = rate
        }
        bitcoinRateService.startFetching(interval: 300) // Fetch every 5 minutes
    }

    func updateBalance() {
        balance = coreDataManager.getBalance()
    }
}
