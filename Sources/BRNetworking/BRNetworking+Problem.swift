//
//  BRNetworking+Problem.swift
//  
//
//  Created by Ben Roaman on 3/19/25.
//

import Foundation

public extension BRNetworking {
    /// Represents various problems that can occur during calls
    enum Problem: Error {
        /// Represents a response with a non-200s code
        /// - Parameters:
        ///   - code: The response code
        ///   - responseBody: The body of the response
        case badResponse(code: Int, responseBody: Data)
        /// Represents when a call succeeds, but decoding the response body fails
        /// - Parameters:
        ///   - error: The decoding error
        ///   - responseBody: The body of the response
        case cannotDecodeResponse(error: Error, responseBody: Data)
        /// Represents when the request body fails to encode
        /// - Parameters:
        ///   - error: The encoding error
        ///   - object: The request body object for which encoding failed
        case cannotEncodeBody(error: Error, object: Any)
        /// Represents when an HTTPMethod is invoked that requires a request body, but no request body is provided
        /// - Parameters:
        ///   - method: The HTTP Method invoked without a request body
        case missingBody(method: HTTPMethod)
        /// Represents when the URLSession returns a URLResponse that is not an HTTPURLResponse
        /// - Note: Only possible if you attempt to use a non-HTTP URL, which is not supported by this library
        case invalidResponseType
        /// Represents an error that is not represented by any of the other cases
        /// - Parameters:
        ///   - error: The error that was thrown.
        case unknown(error: Error?)
    }
}
