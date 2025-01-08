//
//  MockAnalyticsService.swift
//  TransactionsTestTask
//
//  Created by Oleh Veheria on 08.01.2025.
//

import Foundation
@testable import TransactionsTestTask

final class MockAnalyticsService: AnalyticsService {
    private(set) var trackedEvents: [AnalyticsEvent] = []

    func trackEvent(name: String, parameters: [String: String]) {
        let event = AnalyticsEvent(name: name, parameters: parameters, date: Date())
        trackedEvents.append(event)
    }

    func getEvents(name: String?, dateRange: ClosedRange<Date>?) -> [AnalyticsEvent] {
        return trackedEvents.filter { event in
            let matchesName = name == nil || event.name == name
            let matchesDate = dateRange == nil || dateRange!.contains(event.date)
            return matchesName && matchesDate
        }
    }
}
