//
//  MockURLSession.swift
//  TransactionsTestTask
//
//  Created by Oleh Veheria on 09.01.2025.
//

import XCTest
@testable import TransactionsTestTask

class MockURLSession: URLSession {
    var data: Data?
    var response: URLResponse?
    var error: Error?

    override func dataTask(
        with url: URL,
        completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void
    ) -> URLSessionDataTask {
        return MockURLSessionDataTask {
            completionHandler(self.data, self.response, self.error)
        }
    }
}
