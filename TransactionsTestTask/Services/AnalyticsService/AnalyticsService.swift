//
//  AnalyticsService.swift
//  TransactionsTestTask
//

import Foundation

/// Analytics Service is used for events logging
/// Tracks events and allows retrieval with filters
/// The service should be covered by unit tests
protocol AnalyticsService: AnyObject {
    func trackEvent(name: String, parameters: [String: String])
    func getEvents(name: String?, dateRange: ClosedRange<Date>?) -> [AnalyticsEvent]
}

final class AnalyticsServiceImpl {

    private var events: [AnalyticsEvent] = []

    // MARK: - Init

    init() {}
}

extension AnalyticsServiceImpl: AnalyticsService {

    func trackEvent(name: String, parameters: [String: String]) {
        let event = AnalyticsEvent(
            name: name,
            parameters: parameters,
            date: .now
        )
        events.append(event)
    }

    func getEvents(name: String?, dateRange: ClosedRange<Date>?) -> [AnalyticsEvent] {
        return events.filter { event in
            let matchesName = name == nil || event.name == name
            let matchesDate = dateRange == nil || dateRange!.contains(event.date)
            return matchesName && matchesDate
        }
    }
}
