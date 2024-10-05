//
//  File.swift
//  BBNetwork
//
//  Created by 김건우 on 9/25/24.
//

import Foundation

import Alamofire

// MARK: - Session Manager

public protocol BBNetworkSession {
    typealias CompletionHandler = (Data?, URLResponse?, (any Error)?) -> Void
    
    var af: Session { get }
    
    func request(with request: URLRequest, completion: @escaping CompletionHandler) -> BBNetworkCancellable
}


// MARK: - Network Session

public class BBBaseNetworkSession {
    public let interceptor: (any RequestInterceptor)?
    public let eventMonitors: [any EventMonitor]?
    
    public init(interceptor: (any RequestInterceptor)? = nil, eventMonitors: [any EventMonitor]? = nil) {
        self.interceptor = interceptor
        self.eventMonitors = eventMonitors
    }
    func createSession() -> Session {
        Session(interceptor: interceptor, eventMonitors: eventMonitors ?? [])
    }
}

extension BBBaseNetworkSession: BBNetworkSession {
    public var af: Session {
        createSession()
    }
    public func request(
        with request: URLRequest,
        completion: @escaping CompletionHandler
    ) -> BBNetworkCancellable {
        let sessionDataTask = af.session.dataTask(with: request, completionHandler: completion)
        sessionDataTask.resume()
        return sessionDataTask
    }
}


// MARK: - Default Session

public class BBNetworkDefaultSession: BBBaseNetworkSession {
    public override init(
        interceptor: (any RequestInterceptor)? = BBNetworkDefaultInterceptor(),
        eventMonitors: [any EventMonitor]? = [BBNetworkDefaultEventMonitor()]
    ) {
        super.init(interceptor: interceptor, eventMonitors: eventMonitors)
    }
}


// MARK: - Refresh Session

public class BBNetworkRefreshSession: BBBaseNetworkSession {
    public init(
        eventMonitors: [any EventMonitor]? = [BBNetworkDefaultEventMonitor()]
    ) {
        super.init(interceptor: nil, eventMonitors: eventMonitors)
    }
}
