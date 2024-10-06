//
//  BBAPIErrorResolver.swift
//  Core
//
//  Created by 김건우 on 10/5/24.
//

import Foundation

// MARK: - API Error Resolver

public protocol APIErrorResolver {
    func resolve(networkError error: any Error) -> APIWorkerError
}


// MARK: - Default API Error Resolver

public struct APIDefaultErrorResolver: APIErrorResolver {
    
    public init() { }
    
    /// `Error` 타입의 에러를 `APIWorkerError` 타입의 에러로 변환합니다.
    ///
    /// 적합한 케이스로 변환이 어렵다면 `.unknown` 에러로 변환합니다.
    ///
    /// - Parameter error: `Error` 프로토콜을 준수하는 에러입니다.
    /// - Returns: `APIWorkerError`
    public func resolve(networkError error: any Error) -> APIWorkerError {
        if let error = error as? BBNetworkError {
            return .networkFailure(reason: error)
        }
        return .unknown(error)
    }
    
}
