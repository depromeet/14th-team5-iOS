//
//  File.swift
//  BBNetwork
//
//  Created by 김건우 on 9/25/24.
//

import Alamofire
import Foundation

// MARK: - BBSession

public struct BBSession {
    
    static let `default`: Session = {
        let eventMonitor = BBEventMonitor()
        let interceptor = BBIntercepter()
        let session = Session(interceptor: interceptor, eventMonitors: [eventMonitor])
        return session
    }()
    
}
