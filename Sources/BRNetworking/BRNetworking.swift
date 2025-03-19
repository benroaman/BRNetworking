//
//  BRNetworking.swift
//
//
//  Created by Ben Roaman on 3/15/25.
//

import Foundation

// MARK: Base
public struct BRNetworking {
    private init() { }
    
    // MARK: Typaliases
    internal typealias ResponsePackage = (data: Data, response: URLResponse)
    
    // MARK: Static Constants - URLSessions
    internal static let defaultDataSession = URLSession(configuration: BRNetworking.defaultConfig)
    internal static let defaultUploadSession = URLSession(configuration: BRNetworking.defaultConfig)
    
    // MARK: Static Constants - Coding
    internal static let defaultDecoder = JSONDecoder()
    internal static let defaultEncoder = JSONEncoder()
    
    // MARK: Static Variables
    /// Use this value to determine what BRCoding will log
    /// - See ``BRNetworking/LogStyle`` for behavior
    public static var logStyle: LogStyle = .complete
    
    // MARK: Static Computed Values - URLSessionConfigurations
    internal static var defaultConfig: URLSessionConfiguration {
        let config = URLSessionConfiguration.default
        config.allowsCellularAccess = true
        config.timeoutIntervalForRequest = 15
        config.timeoutIntervalForResource = 30
        return config
    }
    
}

// MARK: Public API - Calls
public extension BRNetworking {
    /// Makes an asynchronous network request with a request body and a response body.
    ///
    /// - Parameters:
    ///   - url: The endpoint URL to which the request is sent.
    ///   - method: The HTTP method (e.g., `GET`, `POST`) used for the request.
    ///   - headers: Optional dictionary of HTTP headers to include in the request.
    ///   - requestBody: The request body conforming to `Encodable`.
    ///   - session: An optional `URLSession` instance to use for the request. Defaults to `nil`, using the default upload session.
    ///   - encoder: An optional `JSONEncoder` for encoding the request body. Defaults to `nil`, using the default encoder.
    ///   - decoder: An optional `JSONDecoder` for decoding the response body. Defaults to `nil`, using the default decoder.
    ///
    /// - Returns:
    ///   A `Result` containing either a `ResponseBody` or a ``Problem``
    static func call<RequestBody: Encodable, ResponseBody: Decodable>(url: URL,
                                                                      method: HTTPMethod,
                                                                      headers: [String: String]?,
                                                                      requestBody: RequestBody,
                                                                      session: URLSession? = nil,
                                                                      encoder: JSONEncoder? = nil,
                                                                      decoder: JSONDecoder? = nil) async -> Result<ResponseBody, Problem> {
        do {
            let responsePackage = try await getResponse(url: url,
                                                        method: method,
                                                        headers: headers,
                                                        requestBody: requestBody,
                                                        encoder: encoder ?? defaultEncoder,
                                                        session: session ?? defaultUploadSession)
            return parseResponse(package: responsePackage, 
                                 ResponseBody.self,
                                 decoder: decoder ?? defaultDecoder)
        } catch {
            return .failure((error as? Problem) ?? .unknown(error: error))
        }
    }
    
    /// Makes an asynchronous network request with no request body and no response body.
    ///
    /// - Parameters:
    ///   - url: The endpoint URL to which the request is sent.
    ///   - method: The HTTP method (e.g., `GET`, `POST`) used for the request.
    ///   - headers: Optional dictionary of HTTP headers to include in the request.
    ///   - session: An optional `URLSession` instance to use for the request. Defaults to `nil`, using the default upload session.
    ///
    /// - Returns:
    ///   A `Result` containing either a `ResponseBody` or a ``Problem``
    static func callWithoutResponse(url: URL,
                                    method: HTTPMethod,
                                    headers: [String: String]?,
                                    session: URLSession? = nil) async -> Result<Int, Problem> {
        
        guard !method.requiresRequestBody else { return .failure(.missingBody(method: method)) }
        
        do {
            let request = makeRequest(for: url,
                                      method: method,
                                      headers: headers)
            return parseResponse(package: try await (session ?? defaultDataSession).data(for: request))
        } catch {
            return .failure((error as? Problem) ?? .unknown(error: error))
        }
    }
    
    /// Makes an asynchronous network request with a request body and no response body.
    ///
    /// - Parameters:
    ///   - url: The endpoint URL to which the request is sent.
    ///   - method: The HTTP method (e.g., `GET`, `POST`) used for the request.
    ///   - headers: Optional dictionary of HTTP headers to include in the request.
    ///   - requestBody: The request body conforming to `Encodable`.
    ///   - encoder: An optional `JSONEncoder` for encoding the request body. Defaults to `nil`, using the default encoder.
    ///   - session: An optional `URLSession` instance to use for the request. Defaults to `nil`, using the default upload session.
    ///
    /// - Returns:
    ///   A `Result` containing either a `ResponseBody` or a ``Problem``
    static func callWithoutResponse<RequestBody: Encodable>(url: URL,
                                                            method: HTTPMethod,
                                                            headers: [String: String]?,
                                                            requestBody: RequestBody,
                                                            session: URLSession? = nil,
                                                            encoder: JSONEncoder? = nil) async -> Result<Int, Problem> {
        do {
            let responsePackage = try await getResponse(url: url,
                                                        method: method,
                                                        headers: headers,
                                                        requestBody: requestBody,
                                                        encoder: encoder ?? defaultEncoder,
                                                        session: session ?? defaultUploadSession)
            return parseResponse(package: responsePackage)
        } catch {
            return .failure((error as? Problem) ?? .unknown(error: error))
        }
    }
    
    /// Makes an asynchronous network request with no request body and a response body.
    ///
    /// - Parameters:
    ///   - url: The endpoint URL to which the request is sent.
    ///   - method: The HTTP method (e.g., `GET`, `POST`) used for the request.
    ///   - headers: Optional dictionary of HTTP headers to include in the request.
    ///   - session: An optional `URLSession` instance to use for the request. Defaults to `nil`, using the default upload session.
    ///   - decoder: An optional `JSONDecoder` for decoding the response body. Defaults to `nil`, using the default decoder.
    ///
    /// - Returns:
    ///   A `Result` containing either a `ResponseBody` or a ``Problem``
    static func call<ResponseBody: Decodable>(url: URL,
                                              method: HTTPMethod,
                                              headers: [String: String]?,
                                              session: URLSession? = nil,
                                              decoder: JSONDecoder? = nil) async -> Result<ResponseBody, Problem> {
        
        guard !method.requiresRequestBody else { return .failure(.missingBody(method: method)) }
        
        do {
            let request = makeRequest(for: url, method: method, headers: headers)
            let responsePackage = try await (session ?? defaultDataSession).data(for: request)
            return parseResponse(package: responsePackage,
                                 ResponseBody.self,
                                 decoder: decoder ?? defaultDecoder)
        } catch {
            return .failure((error as? Problem) ?? .unknown(error: error))
        }
    }
}

// MARK: Private API
private extension BRNetworking {
    /// Parse response package while ignoring response body
    static func parseResponse(package: ResponsePackage) -> Result<Int, Problem> {
        guard let response = package.response as? HTTPURLResponse else { return .failure(.invalidResponseType) }
        if isResponseSuccess(response) {
            logSuccess(response)
            return .success(response.statusCode)
        } else {
            logFailure(response)
            logData(package.data, direction: .incoming)
            return .failure(.badResponse(code: response.statusCode, responseBody: package.data))
        }
    }
    
    /// Parse response package and decode response body
    static func parseResponse<ResponseBody: Decodable>(package: ResponsePackage, _ ResponseBody: ResponseBody.Type, decoder: JSONDecoder) -> Result<ResponseBody, Problem> {
        guard let response = package.response as? HTTPURLResponse else { return .failure(.invalidResponseType) }
        
        if isResponseSuccess(response) {
            logSuccess(response)
            logData(package.data, direction: .incoming)
            do {
                return .success(try decoder.decode(ResponseBody.self, from: package.data))
            } catch {
                #warning("TODO: Log this failure")
                return .failure(.cannotDecodeResponse(error: error, responseBody: package.data))
            }
        } else {
            logFailure(response)
            logData(package.data, direction: .incoming)
            return .failure(.badResponse(code: response.statusCode, responseBody: package.data))
        }
    }
    
    /// Create and execute a task that includes a request body
    static func getResponse<RequestBody: Encodable>(url: URL, method: HTTPMethod, headers: [String: String]?, requestBody: RequestBody, encoder: JSONEncoder, session: URLSession) async throws -> ResponsePackage {
        let requestBodyData: Data
        
        do {
            requestBodyData = try encoder.encode(requestBody)
            logData(requestBodyData, direction: .outgoing)
        } catch {
            #warning("TODO: Log this Failure")
            throw Problem.cannotEncodeBody(error: error, object: requestBody)
        }
        
        do {
            return try await session.upload(for: makeRequest(for: url, method: method, headers: headers), from: requestBodyData)
        } catch {
            throw error
        }
    }
    
    /// Sythesize a URLRequest from a url, HTTP method and header dictionary
    static func makeRequest(for url: URL, method: HTTPMethod, headers: [String: String]?) -> URLRequest {
        logRequest(method, url: url, headers: headers)
        
        // Create request
        var request = URLRequest(url: url)
        // Set Method
        request.httpMethod = method.rawValue
        
        // Set headers if they are provided
        if let headers = headers {
            for key in headers.keys {
                guard let value = headers[key] else { continue }
                
                if let _ = request.value(forHTTPHeaderField: key) {
                    request.setValue(value, forHTTPHeaderField: key)
                } else {
                    request.addValue(value, forHTTPHeaderField: key)
                }
            }
        }
        
        return request
    }
    
    /// Determines if the `statusCode` of an `HTTPURLResponse` falls in the success range
    static func isResponseSuccess(_ response: HTTPURLResponse) -> Bool {
        response.statusCode < 300 && response.statusCode >= 200
    }
}
