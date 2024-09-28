//
//  APISpec.swift
//  BBNetwork
//
//  Created by 김건우 on 9/25/24.
//

import Foundation

/// API 요청에 필요한 재료 묶음인 Spec입니다.
///
/// 호출 메소드, 호출 URL, 요청 바디와 헤더가 포함되어 있습니다.
///
/// - Authors: 김소월
public struct BBAPISpec {
    
    /// 호출 메서드입니다.
    public let method: BBAPIMethod
    
    /// 호출하고자 하는 API의 URL 경로입니다.
    ///
    /// 베이스 URL을 제외한 나머지 URL만 작성해야 합니다. 예를 들어, 전체 URL이 **https://api.oing.kr/v1/families/{familyId}/name**라면 베이스 URL을 제외한 **/families/{familyId}/name**만 작성해야 합니다.
    public let path: String
    
    /// 호출하고자 하는 API의 쿼리 파라미터입니다.
    ///
    /// `path` 프로퍼티에서 모든 쿼리 파라미터를 포함시킬 수 있지만, 더욱 깔끔하게 Spec을 작성하려면 해당 프로퍼티를 작성하세요.
    /// 자주 사용되는 쿼리 파라미터 키와 값은 미리 정의되어 있습니다. 별도 키와 값을 사용하고 싶다면, 문자열을 입력하세요.
    ///
    /// - Warning: `path` 프로퍼티에 쿼리 파라미터를 함께 적어주었다면 해당 프로퍼티에 값을 전달하면 안됩니다.
    ///
    public let parameters: BBParameters?
    
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
        path: String,
        parameters: BBParameters? = nil,
        requestBody: (any Encodable)? = nil,
        headers: BBAPIHeaders = BBAPIHeader.default
    ) {
        self.method = method
        self.path = path
        self.parameters = parameters
        self.requestBody = requestBody
        self.headers = headers
    }
    
}


// MARK: - Extension

public extension BBAPISpec {
    
    /// 정제된 URL 문자열을 반환합니다.
    var urlString: String {
        var urlString: String = path
        urlString = normalizeUrl(urlString)
        return urlString
    }
    
}

private extension BBAPISpec {
    
    // 기초 URL을 반환합니다.
    var _baseURL: String {
        return BBAPIConfiguration.baseUrl
    }
    
    /// `path` 프로퍼티로 주어진 URL을 바탕으로 베이스 URL을 추가하고, 유효한 URL인지 검사합니다.
    func normalizeUrl(_ dirtyUrlString: String) -> String {
        var urlString = dirtyUrlString
        urlString = prependBaseUrl(urlString)
        urlString = sanitizeUrlWithRegex(urlString)
        urlString = appendQueryParamter(urlString)
        return urlString
    }
    
    /// `path` 프로퍼티 앞에 베이스 URL을 추가합니다.
    func prependBaseUrl(_ dirtyUrlString: String) -> String {
        var urlString = dirtyUrlString
        if !dirtyUrlString.hasPrefix(_baseURL) {
            urlString = _baseURL + path
        }
        return urlString
    }

    /// 주어진 URL이 유효한 URL인지 검사하고 수정합니다.
    func sanitizeUrlWithRegex(_ dirtyUrlString: String) -> String {
        var urlString = dirtyUrlString
        urlString = replaceRegex(":/{3,}", "://", urlString)
        urlString = replaceRegex("(?<!:)/{2,}", "/", urlString)
        urlString = replaceRegex("(?<!:|:/)/+$", "", urlString)
        return urlString
    }
    
    /// 주어진 URL에 쿼리 파라미터를 추가합니다.
    func appendQueryParamter(_ dirtyUrlString: String) -> String {
        var urlString = dirtyUrlString
        if let parameters = parameters {
            urlString += "?"
            let queries: [String] = parameters.map { key, value in
                "\(key.rawValue)=\(value.rawValue)"
            }
            urlString += queries.joined(separator: "&")
        }
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
