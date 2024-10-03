//
//  BBNetworkHeader.swift
//  BBNetwork
//
//  Created by 김건우 on 9/25/24.
//

import Foundation

import Alamofire

// MARK: - Typealias

public typealias BBNetworkHeaders = [BBNetworkHeader]


// MARK: - Header

/// 서버에 전달하는 부가적인 정보입니다.
public enum BBNetworkHeader {
    
    case xAppKey
    case xAuthToken
    case xUserPlatform
    case xUserId
    case contentType
    
}


// MARK: - Extensions

public extension BBNetworkHeaders {
    
    /// 가장 일반적인 헤더 모음입니다.
    static var `default`: [BBNetworkHeader] {
        [.xAppKey, .xAuthToken, .xUserPlatform, .xUserId, .contentType]
    }
    
    /// 인증이 필요없는 API 요청에 사용되는 헤더 모음입니다.
    static var unAuthorized: [BBNetworkHeader] {
        [.xAppKey, .xUserPlatform, .contentType]
    }
    
}

public extension BBNetworkHeader {
    
    /// 헤더의 키입니다.
    var key: String {
        switch self {
        case .xAppKey: return "X-APP-KEY"
        case .xAuthToken: return "X-AUTH-TOKEN"
        case .xUserPlatform: return "X-USER-PLATFORM"
        case .xUserId: return "X-USER-ID"
        case .contentType: return "Content-Type"
        }
    }
    
    /// 헤더가 가지는 실질적인 값입니다.
    var value: String {
        switch self {
        case .xAppKey: return fetchXAppKey()
        case .xAuthToken: return fetchXAuthTokenValue()
        case .xUserPlatform: return fetchXUserPlatform()
        case .xUserId: return fetchXuserId()
        case .contentType: return fetchContentType()
        }
    }
    
    /// `BBNetworkHeader`를 Alamofire의 `HTTPHeader` 타입으로 변환합니다.
    var asHTTPHeader: HTTPHeader {
        HTTPHeader(name: key, value: value)
    }
    
}

private extension BBNetworkHeader {
    
    func fetchXAppKey() -> String {
        // TODO: - Bundle에서 Key를 가져오도록 코드 수정하기
        return "7c5aaa36-570e-491f-b18a-26a1a0b72959"
    }

    func fetchXAuthTokenValue() -> String {
        let keychain = KeychainWrapper.standard
        guard
            let string = keychain.string(forKey: .accessToken),
            let encodedData = string.data(using: .utf8),
            let accessToken = encodedData.decode(AccessToken.self)
        else { return "" /* 예외 코드 작성 */ }
        
        return accessToken.accessToken ?? "" /* 예외 코드 작성 */
    }

    func fetchXUserPlatform() -> String {
        // TODO: - Bundle에서 Platform을 가져오도록 코드 수정하기
        return "iOS"
    }
    
    func fetchXuserId() -> String {
        let userDefaults = UserDefaultsWrapper.standard
        guard
            let memberId = userDefaults.string(forKey: .memberId)
        else { return "" /* 예외 코드 작성 */ }
        
        return memberId /* 예외 코드 작성 */
    }
    
    func fetchContentType() -> String {
        return "application/json"
    }
    
}

public extension Array where Element == BBNetworkHeader {
    
    /// `[BBNetworkHeader]`를 Alamofire의 `HTTPHeaders` 타입으로 변환합니다.
    var asHTTPHeaders: HTTPHeaders {
        HTTPHeaders(self.map { $0.asHTTPHeader })
    }
    
}
