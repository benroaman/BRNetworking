//
//  File.swift
//  
//
//  Created by Ben Roaman on 3/19/25.
//

import Foundation

// MARK: Public API - Default Decoder Settings
public extension BRNetworking {
    /// Use to set `keyDecodingStrategy` on the default decoder
    /// - See [JSONEncoder.KeyEncodingStrategy](https://developer.apple.com/documentation/foundation/jsonencoder/keyencodingstrategy)
    static func setDefaultDecoderKeyDecodingStrategy(_ keyDecodingStrategy: JSONDecoder.KeyDecodingStrategy) {
        Self.defaultDecoder.keyDecodingStrategy = keyDecodingStrategy
    }
    
    /// Use to set `userInfo` on the default decoder
    /// - See [JSONEncoder.userInfo](https://developer.apple.com/documentation/foundation/jsondecoder/2895340-userinfo)
    static func setDefaultDecoderUserInfo(_ userInfo: [CodingUserInfoKey: Any]) {
        Self.defaultDecoder.userInfo = userInfo
    }
    
    /// Use to set `allowsJSON5` on the default decoder
    /// - See [JSONEncoder.allowsJSON5](https://developer.apple.com/documentation/foundation/jsondecoder/3766916-allowsjson5)
    static func setDefaultDecoderAllowsJSON5(_ allowsJSON5: Bool) {
        Self.defaultDecoder.allowsJSON5 = allowsJSON5
    }
    
    /// Use to set `assumesTopLevelDictionary` on the default decoder
    /// - See [JSONEncoder.assumesTopLevelDictionary](https://developer.apple.com/documentation/foundation/jsondecoder/3766917-assumestopleveldictionary)
    static func setDefaultDecoderAssumesTopLevelDictionary(_ assumesTopLevelDictionary: Bool) {
        Self.defaultDecoder.assumesTopLevelDictionary = assumesTopLevelDictionary
    }
    
    /// Use to set `dateDecodingStrategy` on the default decoder
    /// - See [JSONEncoder.dateDecodingStrategy](https://developer.apple.com/documentation/foundation/jsondecoder/2895108-datadecodingstrategy)
    static func setDefaultDecoderDateDecodingStrategy(_ dateDecodingStrategy: JSONDecoder.DateDecodingStrategy) {
        Self.defaultDecoder.dateDecodingStrategy = dateDecodingStrategy
    }
    
    /// Use to set `nonConformingFloatDecodingStrategy` on the default decoder
    /// - See [JSONEncoder.nonConformingFloatDecodingStrategy](https://developer.apple.com/documentation/foundation/jsondecoder/2895076-nonconformingfloatdecodingstrate)
    static func setDefaultDecoderNonConformingFloatDecodingStrategy(_ nonConformingFloatDecodingStrategy: JSONDecoder.NonConformingFloatDecodingStrategy) {
        Self.defaultDecoder.nonConformingFloatDecodingStrategy = nonConformingFloatDecodingStrategy
    }
}

// MARK: Public API - Default Encoder Settings
public extension BRNetworking {
    /// Use to set `outputFormatting` on the default encoder
    /// - See [JSONEncoder.outputFormatting](https://developer.apple.com/documentation/foundation/jsonencoder/2895284-outputformatting)
    static func setDefaultEncoderOutputFormatting(_ outputFormatting: JSONEncoder.OutputFormatting) {
        Self.defaultEncoder.outputFormatting = outputFormatting
    }
    
    /// Use to set `keyEncodingStrategy` on the default encoder
    /// - See [JSONEncoder.keyEncodingStrategy](https://developer.apple.com/documentation/foundation/jsonencoder/2949141-keyencodingstrategy)
    static func setDefaultEncoderKeyEncodingStrategy(_ keyEncodingStrategy: JSONEncoder.KeyEncodingStrategy) {
        Self.defaultEncoder.keyEncodingStrategy = keyEncodingStrategy
    }
    
    /// Use to set `userInfo` on the default encoder
    /// - See [JSONEncoder.userInfo](https://developer.apple.com/documentation/foundation/jsonencoder/2895176-userinfo)
    static func setDefaultEncoderUserInfo(_ userInfo: [CodingUserInfoKey: Any]) {
        Self.defaultEncoder.userInfo = userInfo
    }
    
    /// Use to set `dateEncodingStrategy` on the default encoder
    /// - See [JSONEncoder.dateEncodingStrategy](https://developer.apple.com/documentation/foundation/jsonencoder/2895363-dateencodingstrategy)
    static func setDefaultEncoderDateEncodingStrategy(_ dateEncodingStrategy: JSONEncoder.DateEncodingStrategy) {
        Self.defaultEncoder.dateEncodingStrategy = dateEncodingStrategy
    }
    
    /// Use to set `nonConformingFloatEncodingStrategy` on the default encoder
    /// - See [JSONEncoder.nonConformingFloatEncodingStrategy](https://developer.apple.com/documentation/foundation/jsonencoder/2895199-nonconformingfloatencodingstrate)
    static func setDefaultEncoderNonConformingFloatEncodingStrategy(_ nonConformingFloatEncodingStrategy: JSONEncoder.NonConformingFloatEncodingStrategy) {
        Self.defaultEncoder.nonConformingFloatEncodingStrategy = nonConformingFloatEncodingStrategy
    }
}

// MARK: Public API - Default Session Settings
public extension BRNetworking {
    /// Use to set `allowsCellularAccess` on the configurations of the default sessions
    /// - See [URLSessionConfiguration.allowsCellularAccess](https://developer.apple.com/documentation/foundation/urlsessionconfiguration/1409406-allowscellularaccess)
    static func setDefaultSessionsAllowsCellularAccess(_ allowsCellularAccess: Bool) {
        Self.defaultDataSession.configuration.allowsCellularAccess = allowsCellularAccess
        Self.defaultUploadSession.configuration.allowsCellularAccess = allowsCellularAccess
    }
    
    /// Use to set `timeoutIntervalForRequest` on the configurations of the default sessions
    /// - See [URLSessionConfiguration.timeoutIntervalForRequest](https://developer.apple.com/documentation/foundation/urlsessionconfiguration/1408259-timeoutintervalforrequest)
    static func setDefaultSessionsTimeoutIntervalForRequest(_ timeoutIntervalForRequest: TimeInterval) {
        Self.defaultDataSession.configuration.timeoutIntervalForRequest = timeoutIntervalForRequest
        Self.defaultUploadSession.configuration.timeoutIntervalForRequest = timeoutIntervalForRequest
    }

    /// Use to set `timeoutIntervalForResource` on the configurations of the default sessions
    /// - See [URLSessionConfiguration.timeoutIntervalForResource](https://developer.apple.com/documentation/foundation/urlsessionconfiguration/1408153-timeoutintervalforresource)
    static func setDefaultSessionsTimeoutIntervalForResource(_ timeoutIntervalForResource: TimeInterval) {
        Self.defaultDataSession.configuration.timeoutIntervalForResource = timeoutIntervalForResource
        Self.defaultUploadSession.configuration.timeoutIntervalForResource = timeoutIntervalForResource
    }
    
    /// Use to set `waitsForConnectivity` on the configurations of the default sessions
    /// - See [URLSessionConfiguration.waitsForConnectivity](https://developer.apple.com/documentation/foundation/urlsessionconfiguration/2908812-waitsforconnectivity)
    static func setDefaultSessionsWaitForConnectivity(_ waitForConnectivity: Bool) {
        Self.defaultDataSession.configuration.waitsForConnectivity = waitForConnectivity
        Self.defaultUploadSession.configuration.waitsForConnectivity = waitForConnectivity
    }
}
