//
//  OAuthAPIs.swift
//  Data
//
//  Created by 김건우 on 6/6/24.
//

import Core
import Domain
import Foundation

enum AuthAPIs: BBAPI {
    // 토큰 재발행
    case refreshToken
    /// 회원가입
    case registerMember
    /// 네이티브 소셜 로그인
    case signIn(SignInType)
    
    var spec: Spec {
        switch self {
        case .refreshToken:
            return .init(
                method: .post,
                path: "/auth/refresh"
            )
        case .registerMember:
            return .init(
                method: .post,
                path: "/auth/register"
            )
        case let .signIn(type):
            return .init(
                method: .post,
                path: "/auth/social/\(type)"
            )
        }
    }
    
    final class Worker: BBRxAPIWorker {
        init() { }
    }
}
