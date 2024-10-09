//
//  BBNetworkErrorLogger.swift
//  Core
//
//  Created by 김건우 on 10/9/24.
//

import Foundation

public struct BBNetworkErrorLogger: BBErrorLogger {
    
    public init() { }
    
    public func log<E>(localizedError error: E) where E : LocalizedError { }
    
}
