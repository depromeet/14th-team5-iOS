//
//  File.swift
//  BBNetwork
//
//  Created by 김건우 on 9/25/24.
//

import Foundation

import Alamofire

// MARK: - SessionProvider

public protocol BBNetworkSession {
    var session: Session { get }
}


// MARK: - BBDefaultSession

public struct BBDefaultNetworkSession: BBNetworkSession {
    
    public let session: Session = {
        let eventMonitor = BBNetworkEventMonitor()
        let interceptor = BBNetworkInterceptor()
        let session = Session(interceptor: interceptor, eventMonitors: [eventMonitor])
        return session
    }()
    
    public init() { }
    
}
