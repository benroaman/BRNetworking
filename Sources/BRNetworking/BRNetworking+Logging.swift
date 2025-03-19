//
//  BRNetworking+Logging.swift
//
//
//  Created by Ben Roaman on 3/19/25.
//

import Foundation

public extension BRNetworking {
    // MARK: LogStyle
    /// OptionSet to determine what BRNetworking will log.
    /// - Options include `callDescriptions`, `callHeaders`, `outgoingJSON`, & `incomingJSON`
    /// - Convenience members `none` & `complete` to easily have no logs or all logs
    /// - Important: If `callDescriptions` is not included, `callHeaders` will be ignored
    struct LogStyle: OptionSet {
        public let rawValue: UInt8
        
        public init(rawValue: UInt8) {
            self.rawValue = rawValue
        }
        
        /// If included, logs descriptions of requests and results
        public static let callDescriptions = LogStyle(rawValue: 1 << 0)
        /// If included, logs headers of requests
        /// - Important: Will be ignored if `callDescriptions` is not also included
        public static let callHeaders = LogStyle(rawValue: 1 << 1)
        /// If included, logs all outgoing JSON
        public static let outgoingJSON = LogStyle(rawValue: 1 << 2)
        /// If included, logs all incoming JSON
        public static let incomingJSON = LogStyle(rawValue: 1 << 3)
        
        /// If provided to `BRNetworking.logStyle`, nothing is logged
        public static var none: Self { [] }
        /// If provided to `BRNetworking.logStyle`, everything is logged
        public static var complete: Self { [.callDescriptions, .callHeaders, .outgoingJSON, .incomingJSON] }
    }
}

internal extension BRNetworking {
    /// Logs `Data` as JSON if `BRNetworking.logStyle` allows
    static func logData(_ data: Data?, direction: BRNetworking.DataDirection) {
        switch direction {
        case .incoming: guard logStyle.contains(.incomingJSON) else { return }
        case .outgoing: guard logStyle.contains(.outgoingJSON) else { return }
        }
        guard let d = data else { return print(direction.logPrefix + "No Data") }
        print(direction.logPrefix + (String(data: d, encoding: .utf8) ?? "invalid JSON"))
    }
    
    /// Logs a failure description for an `HTTPURLResponse` if `BRNetworking.logStyle` allows
    static func logFailure(_ response: HTTPURLResponse) {
        guard logStyle.contains(.callDescriptions) else { return }
        print("Call to \(response.url?.absoluteString ?? "Unknown URL") FAILED - \(response.statusCode)")
    }
    
    /// Logs a success description for an `HTTPURLResponse` if `BRNetworking.logStyle` allows
    static func logSuccess(_ response: HTTPURLResponse) {
        guard logStyle.contains(.callDescriptions) else { return }
        print("Call to \(response.url?.absoluteString ?? "Unknown URL") SUCCEEDED - \(response.statusCode)")
    }
    
    /// Logs a description of a request if `BRNetworking.logStyle` allows
    static func logRequest(_ method: HTTPMethod, url: URL, headers: [String: String]?) {
        guard logStyle.contains(.callDescriptions) else { return }
        print("Creating \(method.rawValue) Request for URL: \(url.absoluteString)")
        guard logStyle.contains(.callHeaders) else { return }
        print("Headers: \(headers ?? [:])")
    }
}
