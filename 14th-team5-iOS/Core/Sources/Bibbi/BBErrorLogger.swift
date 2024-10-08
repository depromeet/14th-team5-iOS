//
//  BBAPIErrorLogger.swift
//  Core
//
//  Created by 김건우 on 10/5/24.
//

import Foundation

// MARK: - Erorr Logger

public protocol BBErrorLogger {
    func log(error: any Error)
    func log<E>(localizedError error: E) where E: LocalizedError
    func log(data: Data, response: URLResponse)
}

extension BBErrorLogger {
    public func log(error: any Error) { }
    public func log<E>(localizedError error: E) where E: LocalizedError { }
    public func log(data: Data, response: URLResponse) { }
}


// MARK: - APIWorker Error Logger

public struct APIWorkerErrorLogger: BBErrorLogger {
    
    public init() { }
    
    /// 매개변수로 주어진 `Error`의 로그를 출력합니다.
    /// - Parameter error: `Error` 프로토콜을 준수하는 에러입니다.
    public func log<E>(localizedError error: E) where E: LocalizedError {
        var errorLog: String = "-- [APIWorker Error Log] ----------------------------------\n"
        let description = " - DESCRIPTION: \(error.localizedDescription)\n"
        errorLog.append(description)
        print(errorLog + "----------------------------------------------------------\n")
    }
    
}
