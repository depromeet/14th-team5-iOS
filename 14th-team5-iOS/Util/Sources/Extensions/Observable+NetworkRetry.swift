//
//  Observable+NetworkRetry.swift
//  Util
//
//  Created by 김도현 on 2/23/26.
//

import Foundation
import RxSwift

public extension ObservableType {
    
    
    /// - Parameters:
    ///   - maxRetries: 최대 재시도 횟수 (기본값: 3)
    ///   - shouldRetry: 재시도 여부를 판단하는 클로저
    /// - Returns: 재시도 로직이 적용된 Observable
    func retryOnNetworkError(
        maxRetries: Int = 3,
        shouldRetry: ((Error) -> Bool)? = nil
    ) -> Observable<Element> {
        return retry(when: { errors in
            errors.enumerated().flatMap { attempt, error -> Observable<Int> in
                guard attempt < maxRetries else {
                    return .error(error)
                }
                
                let nsError = error as NSError
                
                let isRetryable: Bool
                if let shouldRetry = shouldRetry {
                    isRetryable = shouldRetry(error)
                } else {
                    let retryableErrors: [Int] = [
                        NSURLErrorTimedOut,
                        NSURLErrorNetworkConnectionLost,
                        NSURLErrorNotConnectedToInternet
                    ]
                    isRetryable = retryableErrors.contains(nsError.code)
                }
                
                guard isRetryable else {
                    return .error(error)
                }
                
                let delay = min(pow(2.0, Double(attempt)), 10.0)
                
                BBLogManager.analytics(logType: BBUploadRetryLog(
                    attempt: attempt + 1,
                    maxRetries: maxRetries,
                    errorCode: nsError.code
                ))
                
                return Observable<Int>
                    .timer(.seconds(Int(delay)), scheduler: MainScheduler.instance)
                    .map { _ in attempt }
            }
        })
    }
}
