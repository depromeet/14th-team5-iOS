//
//  BBAPIErrorLogger.swift
//  Core
//
//  Created by 김건우 on 10/5/24.
//

import Foundation

// MARK: - Erorr Logger

public protocol APIErrorLogger {
    func log(error: Error)
}


// MARK: - Default Error Logger

public struct APIDefaultErrorLogger: APIErrorLogger {
    
    public init() { }
    
    public func log(error: any Error) {
        debugPrint("\(error.localizedDescription)")
    }
    
}
