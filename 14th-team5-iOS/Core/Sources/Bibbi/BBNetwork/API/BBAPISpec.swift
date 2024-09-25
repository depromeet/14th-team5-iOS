//
//  APISpec.swift
//  BBNetwork
//
//  Created by 김건우 on 9/25/24.
//

import Foundation
import RegexBuilder

/// API 요청에 필요한 재료 묶음인 Spec입니다.
///
/// 호출 메소드, 호출 URL, 요청 바디와 헤더가 포함되어 있습니다.
///
/// - Authors: 김소월
public struct BBAPISpec {
    
    /// 호출 메서드입니다.
    public let method: BBAPIMethod
    
    /// 호출하고자 API의 URL입니다.
    ///
    /// 베이스 URL을 제외한 나머지 URL만 작성해야 합니다. 예를 들어, 전체 URL이 **https://api.oing.kr/v1/families/{familyId}/name**라면 베이스 URL을 제외한 **/v1/families/{familyId}/name**만 작성해야 합니다.
    public let url: String
    
    /// 요청 바디입니다. Encodable 프로토콜을 준수하는 객체여야 합니다.
    public let requestBody: (any Encodable)?
    
    /// 요청 헤더입니다. 기본값으로 X-App-Key, X-Auth-Token, X-UserId, X-User-Platform이 포함되어 있습니다.
    public let headers: BBAPIHeaders
    
    /// API 요청에 필요한 재료 묶음인 Spec을 만듭니다.
    /// - Parameters:
    ///   - method: 호출 메서드
    ///   - url: 호출 URL (베이스 URL 제외)
    ///   - requestBody: 요청 바디
    ///   - headers: 요청 헤더
    public init(
        method: BBAPIMethod,
        url: String,
        requestBody: (any Encodable)? = nil,
        headers: BBAPIHeaders = BBAPIHeader.default
    ) {
        self.method = method
        self.url = url
        self.requestBody = requestBody
        self.headers = headers
    }
    
}


// MARK: - Extension

public extension BBAPISpec {
    
    private var _baseURL: String {
        return BBAPIConfiguration.baseUrl
    }
    
    /// 정제된 Url 문자열을 반환합니다.
    var urlString: String {
        var urlString: String = url
        urlString = normalizeUrl(urlString)
        return urlString
    }
    
}

private extension BBAPISpec {
    
    func normalizeUrl(_ dirtyUrlString: String) -> String {
        var urlString = dirtyUrlString
        urlString = prependUrl(urlString)
        urlString = sanitizeUrl(urlString)
        return urlString
    }
    
    func prependUrl(_ dirtyUrlString: String) -> String {
        var urlString = dirtyUrlString
        if !dirtyUrlString.hasPrefix(_baseURL) {
            urlString = _baseURL + url
        }
        return urlString
    }

    func sanitizeUrl(_ dirtyUrlString: String) -> String {
        var urlString = dirtyUrlString
        urlString = replaceRegex(":/{3,}", "://", urlString)
        urlString = replaceRegex("(?<!:)/{2,}", "/", urlString)
        urlString = replaceRegex("(?<!:|:/)/+$", "", urlString)
        return urlString
    }
    
    func replaceRegex(
        _ pattern: String,
        _ replacement: String,
        _ string: String
    ) -> String {
        guard
            let regex = try? NSRegularExpression(pattern: pattern, options: [])
        else { return string }
        let range = NSMakeRange(0, string.count)
        return regex.stringByReplacingMatches(in: string, options: [], range: range, withTemplate: replacement)
    }
    
}
