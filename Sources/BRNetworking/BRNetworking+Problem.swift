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
        /// Represents when a provided url string is invalid, for client use only
        /// - Parameters:
        ///   - urlString: The String that was not valid as a URL
        case badURL(urlString: String)
        
    }
    
}

public extension BRNetworking.Problem {
    /// A Description of the error, including any associated data that is reasonable to log
    var description: String {
        switch self {
        case .badResponse(let code, _): return "Bad response code: \(code)"
        case .cannotDecodeResponse(let error, _): return "Cannot decode response body with error: \(error.localizedDescription)"
        case .cannotEncodeBody(let error, _): return "Cannot encode request body with error: \(error.localizedDescription)"
        case .missingBody(let method): return "Missing body for HTTP method \(method.rawValue)"
        case .invalidResponseType: return "Response type is not HTTPURLResponse"
        case .unknown(let error): return "Unclassified error: \(error?.localizedDescription ?? "nil error")"
        case .badURL(let urlString): return "Invalid string passed as for URL: \(urlString)"
        }
    }
}
