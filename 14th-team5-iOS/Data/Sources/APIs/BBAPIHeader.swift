//
//  BBAPIHeader.swift
//  BBNetwork
//
//  Created by 김건우 on 9/25/24.
//

import Foundation

import Alamofire

// MARK: - Typealias

public typealias BBAPIHeaders = [BBAPIHeader]


// MARK: - Header

/// 서버에 전달하는 부가적인 정보입니다.
public enum BBAPIHeader {
    
    case xAppKey
    case xAuthToken
    case xUserPlatform
    case xUserId
    
}


// MARK: - Extensions

public extension BBAPIHeader {
    
    /// 가장 일반적인 헤더 모음입니다.
    static var `default`: [BBAPIHeader] {
        [.xAppKey, .xAuthToken, .xUserPlatform, .xUserId]
    }
    
    /// 인증이 필요없는 API 요청에 사용되는 헤더 모음입니다.
    static var unAuthorized: [BBAPIHeader] {
        [.xAppKey, .xUserPlatform]
    }
    
}

public extension BBAPIHeader {
    
    /// 헤더의 키입니다.
    var key: String {
        switch self {
        case .xAppKey: return "X-APP-KEY"
        case .xAuthToken: return "X-AUTH-TOKEN"
        case .xUserPlatform: return "X-USER-PLATFORM"
        case .xUserId: return "X-USER-ID"
        }
    }
    
    /// 헤더가 가지는 실질적인 값입니다.
    var value: String {
        switch self {
        case .xAppKey: return fetchXppKey()
        case .xAuthToken: return fetchXAuthTokenValue()
        case .xUserPlatform: return fetchXUserPlatform()
        case .xUserId: return fetchXuserId()
        }
    }
    
    /// `BBAPIHeader`를 Alamofire의 `HTTPHeader` 타입으로 변환합니다.
    var asHTTPHeader: HTTPHeader {
        HTTPHeader(name: key, value: value)
    }
    
}

private extension BBAPIHeader {
    
    func fetchXppKey() -> String {
        // TODO: - 번들로 가져오게 수정하기
        return "7c5aaa36-570e-491f-b18a-26a1a0b72959"
    }

    func fetchXAuthTokenValue() -> String {
        // TODO: - 코드 리팩토링하기
        let tokenKeychain = TokenKeychain()
        guard
            let tokenResult: OldAccessToken? = tokenKeychain.loadOldAccessToken(),
            let accessToken: String = tokenResult?.accessToken
        else { return "" }
        
        return accessToken
    }

    func fetchXUserPlatform() -> String {
        return "iOS"
    }
    
    func fetchXuserId() -> String {
        // TODO: - 코드 리팩토링하기
        let myUserDefaults = MyUserDefaults()
        guard
            let memberId: String = myUserDefaults.loadMemberId()
        else { return "" }
        
        return memberId
    }
    
}

public extension Array where Element == BBAPIHeader {
    
    /// `[BBAPIHeader]`를 Alamofire의 `HTTPHeaders` 타입으로 변환합니다.
    var asHTTPHeaders: HTTPHeaders {
        HTTPHeaders(self.map { $0.asHTTPHeader })
    }
    
}
