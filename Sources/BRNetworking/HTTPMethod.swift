//
//  HTTPMethod.swift
//  
//
//  Created by Ben Roaman on 3/15/25.
//

import Foundation

public extension BRNetworking {
    enum HTTPMethod: String {
        case get = "GET"
        case post = "POST"
        case put = "PUT"
        case delete = "DELETE"

        var requiresRequestBody: Bool {
            switch self {
            case .get, .delete: return false
            case .post, .put: return true
            }
        }
    }
}
