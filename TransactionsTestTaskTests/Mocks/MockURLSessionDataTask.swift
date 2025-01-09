//
//  MockURLSessionDataTask.swift
//  TransactionsTestTask
//
//  Created by Oleh Veheria on 09.01.2025.
//

import XCTest
@testable import TransactionsTestTask

class MockURLSessionDataTask: URLSessionDataTask {
    private let closure: () -> Void

    init(closure: @escaping () -> Void) {
        self.closure = closure
    }

    override func resume() {
        closure()
    }
}
