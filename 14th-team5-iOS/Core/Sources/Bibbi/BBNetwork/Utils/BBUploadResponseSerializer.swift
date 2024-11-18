//
//  BBUploadResponseSerializer.swift
//  Core
//
//  Created by 김도현 on 11/18/24.
//

import Foundation

import Alamofire

// MARK: - Upload Response Serializer
public struct BBUploadResponseSerializer: DataResponseSerializerProtocol {
    public typealias SerializedObject = Bool

    public init() { }
    
    
    public func serialize(request: URLRequest?, response: HTTPURLResponse?, data: Data?, error: (any Error)?) throws -> Bool {
        guard let statusCode = response?.statusCode,
              (200..<300) ~= statusCode else {
            throw BBNetworkError.generic(error!)
        }
        
        return true
    }
}
