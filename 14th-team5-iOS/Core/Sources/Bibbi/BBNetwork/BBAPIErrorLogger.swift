//
//  BBAPIErrorLogger.swift
//  Core
//
//  Created by 김건우 on 10/9/24.
//

import Foundation

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
