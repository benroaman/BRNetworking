//
//  File.swift
//  
//
//  Created by Ben Roaman on 3/19/25.
//

import Foundation

internal extension BRNetworking {
    enum DataDirection {
        case incoming, outgoing
        
        var logPrefix: String {
            switch self {
            case .incoming: return "Incoming JSON:\n"
            case .outgoing: return "Outgoing JSON:\n"
            }
        }
    }
}
