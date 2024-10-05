//
//  BBNetworkErrorLogger.swift
//  Core
//
//  Created by 김건우 on 10/5/24.
//

import Foundation

// MARK: - Error

/// 네트워크 통신 중 발생하는 예외입니다.
public enum BBNetworkError: Error {
    
    /// 네트워크에 연결할 수 없음을 의미합니다.
    case notConneted
    
    /// 통신이 취소되었음을 의미합니다.
    case cancelled
    
    /// 기타 네트워크 에러가 발생했음을 의미합니다.
    case generic(Error)
    
    /// URL을 생성할 수 없음을 의미합니다. Spec에 잘못 기재된 요소는 없는지 확인하세요.
    case urlGeneration
    
    /// 네트워크 오류가 발생했음을 의미합니다. 상태 코드를 확인해 직접 원인을 파악해야 합니다.
    case error(statusCode: Int)

}


// MARK: - Error Logger

public protocol BBNetworkErrorLogger {
    func log(error: any Error)
}


// MARK: - Default Error Logger

public struct BBNetworkDefaultErrorLogger: BBNetworkErrorLogger {
    
    public init() { }
    
    public func log(error: any Error) {
        debugPrint("\(error.localizedDescription)")
    }
    
}
