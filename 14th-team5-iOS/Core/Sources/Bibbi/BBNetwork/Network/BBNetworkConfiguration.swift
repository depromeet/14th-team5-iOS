//
//  BBAPIConfiguration.swift
//  BBNetwork
//
//  Created by 김건우 on 9/25/24.
//

import Foundation


// MARK: - APIConfigrable

public protocol NetworkConfigurable {
    var session: any BBNetworkSession { get }
    var timeoutInterval: TimeInterval { get }
    var baseUrl: String { get }
}


// MARK: - DefaultConfiguration

/// 네트워크 기본 설정값입니다.
public struct BBDefaultNetworkConfiguration: NetworkConfigurable {
    
    /// BBNetworkSession  프로토콜을 준수하는 객체입니다.
    public let session: any BBNetworkSession
    
    /// 통신이 종료되기까지 걸리는 시간입니다.
    public let timeoutInterval: TimeInterval
    
    /// 기초 URL을 반환합니다. 빌드 환경에 따라 반환되는 URL이 달라집니다.
    public var baseUrl: String = {
        #if PRD
        return "https://api.no5ing.kr/v1"
        #else
        return "https://dev.api.no5ing.kr/v1"
        #endif
    }()
    
    /// 네트워크 기본 설정값입니다.
    /// - Parameters:
    ///   - session: BBNetworkSession 프로토콜을 준수하는 객체
    ///   - timeoutInterval: 통신 종료까지 걸리는 시간
    public init(
        session: any BBNetworkSession = BBDefaultNetworkSession(),
        timeoutInterval: TimeInterval = 10
    ) {
        self.session = session
        self.timeoutInterval = timeoutInterval
    }
    
}
