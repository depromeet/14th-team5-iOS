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
