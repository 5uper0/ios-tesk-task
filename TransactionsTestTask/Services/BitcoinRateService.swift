//
//  BitcoinRateService.swift
//  TransactionsTestTask
//

import Foundation

/// Protocol for managing Bitcoin rates
protocol BitcoinRateService: AnyObject {
    var onRateUpdate: ((Double) -> Void)? { get set }
    func startFetching(interval: TimeInterval)
    func stopFetching()
    func getCachedRate() -> Double?
}

final class BitcoinRateServiceImpl: BitcoinRateService {

    // MARK: - Properties
    var onRateUpdate: ((Double) -> Void)?
    private var fetchTimer: Timer?
    private let url = URL(string: "https://api.coindesk.com/v1/bpi/currentprice.json")!
    private let analyticsService: AnalyticsService
    private let coreDataManager: CoreDataManager
    private var lastRate: Double?

    // MARK: - Init
    init(analyticsService: AnalyticsService, coreDataManager: CoreDataManager) {
        self.analyticsService = analyticsService
        self.coreDataManager = coreDataManager
    }

    func startFetching(interval: TimeInterval) {
        fetchTimer?.invalidate()
        fetchTimer = Timer.scheduledTimer(withTimeInterval: interval, repeats: true) { [weak self] _ in
            self?.fetchBitcoinRate()
        }
        fetchBitcoinRate()
    }

    func stopFetching() {
        fetchTimer?.invalidate()
        fetchTimer = nil
    }

    func getCachedRate() -> Double? {
        return coreDataManager.fetchBitcoinRate()
    }

    private func fetchBitcoinRate() {
        let task = URLSession.shared.dataTask(with: url) { [weak self] data, response, error in
            guard let self = self, error == nil, let data = data else {
                Logger.logError("Failed to fetch Bitcoin rate: \(error?.localizedDescription ?? "Unknown error")")
                return
            }
            do {
                let bitcoinResponse = try JSONDecoder().decode(BitcoinResponse.self, from: data)
                let rate = bitcoinResponse.bpi.USD.rate_float
                self.lastRate = rate
                self.coreDataManager.saveBitcoinRate(rate: rate, timestamp: Date())
                self.analyticsService.trackEvent(
                    name: "bitcoin_rate_update",
                    parameters: ["rate": String(format: "%.2f", rate)]
                )
                DispatchQueue.main.async {
                    self.onRateUpdate?(rate)
                }
            } catch {
                Logger.logError("Failed to parse Bitcoin rate: \(error)")
            }
        }
        task.resume()
    }
}
