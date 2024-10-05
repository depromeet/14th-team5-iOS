//
//  BBResponseDecoder.swift
//  Data
//
//  Created by 김건우 on 10/2/24.
//

import Foundation

// MARK: - Response Decoder

public protocol BBResponseDecoder {
    func decode<T>(from data: Data) throws -> T where T: Decodable
}


// MARK: - JSON Default Response Decoder

public struct BBDefaultResponderDecoder: BBResponseDecoder {
    private let decoder = JSONDecoder()
    public init() { }
    public func decode<T>(from data: Data) throws -> T where T : Decodable {
        return try decoder.decode(T.self, from: data)
    }
}


// MARK: - JSON Iso8601 Response Decoder

public struct BBIso8601ResponderDecoder: BBResponseDecoder {
    private let decoder = {
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601
        return decoder
    }
    public init() { }
    public func decode<T>(from data: Data) throws -> T where T : Decodable {
        return try decoder().decode(T.self, from: data)
    }
}
