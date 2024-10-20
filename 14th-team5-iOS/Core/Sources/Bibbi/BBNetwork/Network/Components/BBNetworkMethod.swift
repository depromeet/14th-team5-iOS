//
//  BBAPIMethod.swift
//  BBNetwork
//
//  Created by 김건우 on 9/25/24.
//

import Foundation

import Alamofire

/// 서버가 수행해야 할 동작입니다.
public enum BBNetworkMethod {
    
    /// 데이터 조회
    case get
    
    /// 데이터 대체 및 수정
    case put
    
    /// 데이터 추가 및 등록
    case post
    
    /// 데이터 삭제
    case delete
    
}

public extension BBNetworkMethod {
    
    /// `BBAPIMethod`를 `HTTPMethod` 타입으로 변환합니다.
    var asHTTPMethod: HTTPMethod {
        switch self {
        case .get: return HTTPMethod.get
        case .put: return HTTPMethod.put
        case .post: return HTTPMethod.post
        case .delete: return HTTPMethod.delete
        }
    }
    
}
