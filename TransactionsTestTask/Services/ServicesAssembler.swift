//
//  ServicesAssembler.swift
//  TransactionsTestTask
//

import Foundation

/// Services Assembler is used for Dependency Injection
/// Provides a centralized place to create and share services
final class ServicesAssembler {

    // MARK: - Singleton Instance
    static let shared = ServicesAssembler()
    private init() {}

    // MARK: - Lazy Services

    /// Service for tracking analytics events
    lazy var analyticsService: AnalyticsService = {
        AnalyticsServiceImpl()
    }()

    /// CoreData manager for handling database operations
    lazy var coreDataManager: CoreDataManager = {
        CoreDataManagerImpl.shared
    }()

    /// Bitcoin Rate Service for fetching and caching Bitcoin rates
    lazy var bitcoinRateService: BitcoinRateService = {
        BitcoinRateServiceImpl(
            analyticsService: analyticsService,
            coreDataManager: coreDataManager
        )
    }()
}
