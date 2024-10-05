//
//  BBAPIErrorResolver.swift
//  Core
//
//  Created by 김건우 on 10/5/24.
//

import Foundation

// MARK: - API Error Resolver

public protocol APIErrorResolver {
    func resolve(networkError error: BBNetworkError) -> any Error
}


// MARK: - Default API Error Resolver

public struct APIDefaultErrorResolver: APIErrorResolver {
    
    public init() { }
    
    public func resolve(networkError error: BBNetworkError) -> any Error {
        return error
    }
    
}
