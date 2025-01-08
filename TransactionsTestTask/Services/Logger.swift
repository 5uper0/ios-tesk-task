//
//  Logger.swift
//  TransactionsTestTask
//
//  Created by Oleh Veheria on 07.01.2025.
//

import Foundation

final class Logger {

    enum LogLevel: String {
        case debug = "DEBUG"
        case info = "INFO"
        case warning = "WARNING"
        case error = "ERROR"
    }

    static func log(_ level: LogLevel, _ message: String) {
        #if DEBUG
        print("[\(level.rawValue)] \(message)")
        #endif
    }

    static func logDebug(_ message: String) {
        log(.debug, message)
    }

    static func logInfo(_ message: String) {
        log(.info, message)
    }

    static func logWarning(_ message: String) {
        log(.warning, message)
    }

    static func logError(_ message: String) {
        log(.error, message)
    }
}
